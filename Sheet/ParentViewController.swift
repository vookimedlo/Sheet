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
        let constraints = self.constraints(for: source.view)
        sourceCentreXAnchorConstraint = constraints.first
        NSLayoutConstraint.activate(constraints)
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        vc.modalPresentationCapturesStatusBarAppearance = true
        source!.willMove(toParent: nil)
        addChild(vc)
        view.addSubview(destination!.view!)
        destination!.view!.translatesAutoresizingMaskIntoConstraints = false
        let constraints = self.constraints(for: destination.view)
        destinationCentreXAnchorConstraint = constraints.first
        NSLayoutConstraint.activate(constraints)
        destination!.view!.layoutIfNeeded()
        view.layoutIfNeeded()
        runSetNeeds?()
    }
    
    func transitionCleanUp() {
        destination.didMove(toParent: self)
        source.view!.removeFromSuperview()
        source.removeFromParent()
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
    
    private func constraints(for childView: UIView) -> [NSLayoutConstraint] {
        let constraint0 = childView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let constraint1 = childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let constraint2 = childView.widthAnchor.constraint(equalTo: view.widthAnchor)
        constraint2.priority = UILayoutPriority(rawValue: 999)
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "[childView(<=414@1000)]", options: [], metrics: nil, views: ["childView" : childView])
        return [constraint0, constraint1, constraint2] + constraints
    }
}
