import UIKit

public final class SheetManager {
    
    public enum Animation {
        case fade, slideRight, slideLeft
    }
    
    public var chromeTapped: (() -> Void)? {
        didSet {
            transitionHandler.chromeViewTapped = chromeTapped
        }
    }
    
    let parentViewController: ParentViewController
    
    private let transitionHandler = ControllerTransitioningDelegate()
    
    private unowned var root: UIViewController
    
    public init(root: UIViewController, animation: Animation = .slideRight) {
        self.root = root
        switch animation {
        case .fade:
            parentViewController = FadeViewController()
        case .slideRight, .slideLeft:
            let controller = SlideViewController()
            controller.animation = SlideViewController.Animation(animation)
            parentViewController = controller
        }
        parentViewController.transitioningDelegate = transitionHandler
        parentViewController.modalPresentationStyle = .custom
    }
    
    public func present(_ viewController: UIViewController) {
        parentViewController.loadViewIfNeeded()
        parentViewController.show(viewController, sender: self)
        parentViewController.didShowViewController = didShow
        root.present(parentViewController, animated: true)
    }
        
    private func didShow() {
        root.setNeedsStatusBarAppearanceUpdate()
        root.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}
