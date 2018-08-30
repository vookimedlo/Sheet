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
        return children.first
    }
    
    /// During a transition between childViewControllers, there may be a second child viewController.
    var secondaryChild: UIViewController? {
        return children.last
    }
    
    func setup(with vc: UIViewController) {
        vc.loadViewIfNeeded()
        vc.modalPresentationCapturesStatusBarAppearance = true
        view.addSubview(vc.view!)
        addChild(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        vc.didMove(toParent: self)
    }
    
    func setupInitialConstraints(_ traitCollection: UITraitCollection) {
        setupPrimaryChildConstraints(primaryChild!, traitCollection)
    }
    
    func setupPrimaryChildConstraints(_ primaryChild: UIViewController, _ traitCollection: UITraitCollection) {}
    
    override public var childForStatusBarStyle: UIViewController? {
        return children.last
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return children.last
    }
    
    override public var childForStatusBarHidden: UIViewController? {
        return children.last
    }
}
