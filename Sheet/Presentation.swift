import UIKit

final class ControllerAnimator: NSObject {
    var isPresentation: Bool = false
}

extension ControllerAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let detailController = transitionContext.viewController(forKey: isPresentation ? .to : .from)!
        
        if isPresentation {
            transitionContext.containerView.addSubview(detailController.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: detailController)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        detailController.view.frame = initialFrame
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 300,
                       initialSpringVelocity: 5,
                       options: .beginFromCurrentState,
                       animations: {
                        detailController.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

class PresentationController: UIPresentationController {
    
    fileprivate var dimmingView: UIView!
    
    typealias Action = () -> Void
    
    var backgroundTapped: Action?
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        dimmingView.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        backgroundTapped?()
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        let subview = dimmingView!
        subview.translatesAutoresizingMaskIntoConstraints = false
        containerView!.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: containerView!.topAnchor),
            subview.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor)
            ])
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        for child in presentedViewController.childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view!.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }
}

final class CustomPresentationController: PresentationController {
        
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return parentSize
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.frame
    }
}

final class ControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    typealias Action = () -> Void
    
    var chromeViewTapped: Action?
    
    private let animator = ControllerAnimator()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        controller.backgroundTapped = chromeViewTapped
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresentation = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.isPresentation = false
        return animator
    }
}
