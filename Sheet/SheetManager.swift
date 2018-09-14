import UIKit

public final class SheetManager {
    
    /// The transition animation
    ///
    /// - fade: Alpha fade in / out
    /// - slideRight: Each scene slides to the right
    /// - slideLeft: Each scene slides to the left
    /// - custom: No animation. You are expected to provide your own implementation of UIViewControllerAnimatedTransitioning.
    public enum Animation {
        case fade, slideRight, slideLeft, custom
    }
    
    /// The code that executes when a tap gesture is recognised on the shaded area around the scene.
    public var chromeTapped: (() -> Void)? {
        didSet {
            transitionHandler.chromeViewTapped = chromeTapped
        }
    }
    
    private let parentViewController: ParentViewController
    
    private let transitionHandler = ControllerTransitioningDelegate()
    
    private weak var root: UIViewController? {
        didSet {
            parentViewController.runSetNeeds = runSetNeeds
        }
    }
    
    public init(animation: Animation = .fade) {
        switch animation {
        case .custom:
            parentViewController = ParentViewController()
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
    
    /// Presents the presentation scene embedded with a view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to be shown at the embedded initial scene.
    ///   - root: The view controller that is presenting.
    public func show(_ viewController: UIViewController, above root: UIViewController) {
        self.root = root
        let isAppearing = true
        viewController.beginAppearanceTransition(isAppearing, animated: true)
        parentViewController.setup(with: viewController)
        runSetNeeds()
        root.present(parentViewController, animated: true)
        viewController.endAppearanceTransition()
    }
    
    private func runSetNeeds() {
        root!.setNeedsStatusBarAppearanceUpdate()
        root!.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}

extension SheetManager {
    
    @available(*, unavailable, renamed: "init(animation:)")
    public convenience init(root: UIViewController, animation: Animation = .slideRight) { self.init() }
        
    @available(*, unavailable, renamed: "show(above:)")
    public func present(_ viewController: UIViewController) {}
}
