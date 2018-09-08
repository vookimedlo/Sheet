import UIKit

public final class SheetManager {
    
    public enum Animation {
        case fade, slideRight, slideLeft, custom
    }
    
    public var chromeTapped: (() -> Void)? {
        didSet {
            transitionHandler.chromeViewTapped = chromeTapped
        }
    }
    
    private let parentViewController: ParentViewController
    
    private let transitionHandler = ControllerTransitioningDelegate()
    
    private weak var root: UIViewController? {
        didSet {
            parentViewController.didShow = didShow
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
    
    @available(*, deprecated: 2.0.0, renamed: "init(animation:)")
    public init(root: UIViewController, animation: Animation = .slideRight) {
        self.root = root
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
    
    public func show(_ viewController: UIViewController, above root: UIViewController) {
        self.root = root
        parentViewController.setup(with: viewController)
        runSetNeeds()
        root.present(parentViewController, animated: true)
    }
    
    private func didShow() {
        runSetNeeds()
    }
    
    private func runSetNeeds() {
        root!.setNeedsStatusBarAppearanceUpdate()
        root!.setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}

extension SheetManager {
    @available(*, deprecated: 2.0.0, renamed: "show(above:)")
    public func present(_ viewController: UIViewController) {
        parentViewController.loadViewIfNeeded()
        parentViewController.show(viewController, sender: self)
        parentViewController.didShow = didShow
        root!.present(parentViewController, animated: true)
    }
}
