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
    
    var didShow: (() -> Void)?
    
    override public func loadView() {
        self.view = ParentView()
    }
    
    /// A stack of child viewControllers is not maintained. Once a sheet is positioned on screen, any previous child is removed.
    var primaryChild: UIViewController? {
        return childViewControllers.first
    }
    
    /// During a transition between childViewControllers, there may be a second child viewController.
    var secondaryChild: UIViewController? {
        return childViewControllers.last
    }
    
    func setup(with vc: UIViewController) {
        vc.loadViewIfNeeded()
        vc.modalPresentationCapturesStatusBarAppearance = true
        view.addSubview(vc.view!)
        addChildViewController(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        vc.didMove(toParentViewController: self)
    }
    
    func setupInitialConstraints(_ traitCollection: UITraitCollection) {
        setupPrimaryChildConstraints(primaryChild!, traitCollection)
    }
    
    func setupPrimaryChildConstraints(_ primaryChild: UIViewController, _ traitCollection: UITraitCollection) {}
    
    override public var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.last
    }
    
    override public func childViewControllerForHomeIndicatorAutoHidden() -> UIViewController? {
        return childViewControllers.last
    }
    
    override public var childViewControllerForStatusBarHidden: UIViewController? {
        return childViewControllers.last
    }
}
