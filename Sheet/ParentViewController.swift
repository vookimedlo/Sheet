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
    
    func setup(with vc: UIViewController) {
        vc.loadViewIfNeeded()
        vc.modalPresentationCapturesStatusBarAppearance = true
        view.addSubview(vc.view!)
        addChildViewController(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        vc.didMove(toParentViewController: self)
    }
    
    func setupInitialConstraints(_ traitCollection: UITraitCollection) {}
    
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
