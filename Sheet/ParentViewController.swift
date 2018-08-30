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
    
    public override func show(_ vc: UIViewController, sender: Any?) {}
    
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
