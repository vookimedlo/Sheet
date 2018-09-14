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
    
    // MARK: - Constraints
    
    private func constraints(for childView: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(centerXConstraint(for: childView))
        constraints.append(bottomConstraint(for: childView))
        constraints.append(contentsOf: widthConstraints(for: childView))
        return constraints
    }
    
    private func centerXConstraint(for childView: UIView) -> NSLayoutConstraint {
        return childView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    }
    
    private func bottomConstraint(for childView: UIView) -> NSLayoutConstraint {
        return childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    
    private func widthConstraints(for childView: UIView) -> [NSLayoutConstraint] {
        return ChildControllerWidth.constraints(for: childView, inParent: view)
    }
    
    private struct ChildControllerWidth {
        
        static func constraints(for childView: UIView, inParent parent: UIView) -> [NSLayoutConstraint] {
            let constraint = sameAsParent(for: childView, inParent: parent)
            let constraints = maxSize(for: childView)
            return constraints + [constraint]
        }
        
        private static func sameAsParent(for childView: UIView, inParent parent: UIView) -> NSLayoutConstraint {
            let constraint = childView.widthAnchor.constraint(equalTo: parent.widthAnchor)
            constraint.priority = UILayoutPriority(rawValue: 999)
            return constraint
        }
        
        private static func maxSize(for childView: UIView) -> [NSLayoutConstraint] {
            let layout = "[childView(<=414@1000)]"
            let views: [String : Any] = ["childView" : childView]
            return NSLayoutConstraint.constraints(withVisualFormat: layout, options: [], metrics: nil, views: views)
        }
    }
}
