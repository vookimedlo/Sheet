import UIKit

fileprivate final class ParentView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let hitView = subview.hitTest(convertedPoint, with: event) {
                return hitView
            }
        }
        return nil
    }
}

class ParentViewController: UIViewController {
    
    var runSetNeeds: (() -> Void)?
    
    override public func loadView() {
        self.view = ParentView()
    }
    
    var source: UIViewController! {
        return children.first
    }
    
    var destination: UIViewController! {
        return children.last
    }
    
    var constraints: [NSLayoutConstraint]!
    var sourceCentreXAnchorConstraint: NSLayoutConstraint!
    var destinationCentreXAnchorConstraint: NSLayoutConstraint!
    
    func setup(with vc: UIViewController) {
        vc.loadViewIfNeeded()
        vc.modalPresentationCapturesStatusBarAppearance = true
        view.addSubview(vc.view!)
        addChild(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        vc.didMove(toParent: self)
    }
    
    func setupInitialConstraints(_ traitCollection: UITraitCollection) {
        setupSourceConstraints(source, traitCollection)
    }
    
    private func setupSourceConstraints(_ primaryChild: UIViewController, _ traitCollection: UITraitCollection) {
        let constraints = traitCollection.constraints(forChild: source.view, inParent: view)
        sourceCentreXAnchorConstraint = constraints.first
        NSLayoutConstraint.activate(constraints)
        self.constraints = constraints
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        source!.willMove(toParent: nil)
        addChild(vc) // we now have a destination
        view.addSubview(destination!.view!)
        destination!.view!.translatesAutoresizingMaskIntoConstraints = false
        let destinationConstraints = traitCollection.constraints(forChild: destination!.view, inParent: view)
        destinationCentreXAnchorConstraint = destinationConstraints.first
        NSLayoutConstraint.activate(destinationConstraints)
        destination!.view!.layoutIfNeeded()
        view.layoutIfNeeded()
        runSetNeeds?()
    }
    
    func transitionCleanUp() {
        destination.didMove(toParent: self)
        constraints = destination.view!.constraints // destination will become source
        source.view!.removeFromSuperview()
        source.removeFromParent() // popped. source is now destination
    }
    
    override public var childForStatusBarStyle: UIViewController? {
        return children.last
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return children.last
    }
    
    override public var childForStatusBarHidden: UIViewController? {
        return children.last
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        NSLayoutConstraint.deactivate(self.constraints)
        let constraints = newCollection.constraints(forChild: source.view, inParent: view)
        sourceCentreXAnchorConstraint = constraints.first
        NSLayoutConstraint.activate(constraints)
        self.constraints = constraints
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}

private extension UITraitCollection {
    func constraints(forChild childView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor))
        constraints.append(childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor))
        if verticalSizeClass == .regular || verticalSizeClass == .unspecified {
            let constraint = childView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
            constraint.priority = UILayoutPriority(rawValue: 999)
            constraints.append(constraint)
            let views: [String : Any] = ["childView" : childView]
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "[childView(<=414@1000)]", options: [], metrics: nil, views: views))
        } else {
            constraints.append(childView.widthAnchor.constraint(equalTo: parentView.heightAnchor))
        }
        return constraints
    }
}
