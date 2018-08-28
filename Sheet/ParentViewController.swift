import UIKit

final class ParentView: UIView {
    
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
    
    var didShowViewController: (() -> Void)?
    
    override public func loadView() {
        self.view = ParentView()
    }
    
    public override func show(_ vc: UIViewController, sender: Any?) {}
    
    public override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {}
    
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
