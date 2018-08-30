import UIKit

final class SlideViewController: ParentViewController {
    
    var animation: Animation = .slideRight
    
    enum Animation {
        case slideRight, slideLeft
        init(_ animation: SheetManager.Animation) {
            switch animation {
            case .slideRight:
                self = .slideRight
            default:
                self = .slideLeft
            }
        }
    }
    
    private var currentConstraints: [NSLayoutConstraint]?
    
    override func setupInitialConstraints(_ traitCollection: UITraitCollection) {
        guard let child = childViewControllers.last else {
            return
        }
        extractedFunc(child, traitCollection)
        centerXAnchor1 = currentConstraints?.first
    }
    
    private var centerXAnchor1: NSLayoutConstraint!
    private var centerXAnchor2: NSLayoutConstraint!
    
    override func show(_ vc: UIViewController, sender: Any?) {
        
        let child = childViewControllers.last!
        child.willMove(toParentViewController: nil)

        view.addSubview(vc.view!)
        addChildViewController(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        
        if let child = childViewControllers.last {
            for constraint in child.view!.constraints {
                if let firstItem = constraint.firstItem as? UIView {
                    let firstAnchor = constraint.firstAnchor
                    let a = firstItem == child.view!
                    let b = firstAnchor.isEqual(centerXAnchor2)
                    if a && b {
                        centerXAnchor1 = constraint
                        break
                    }
                }
            }
        }
        
        extractedFunc(vc, traitCollection)
        centerXAnchor2 = currentConstraints?.first
        
        let width = view.bounds.width
        
        switch animation {
        case .slideRight:
            centerXAnchor2!.constant -= width
            vc.view!.layoutIfNeeded()
            view.layoutIfNeeded()
            centerXAnchor1!.constant += width
            centerXAnchor2!.constant += width
        case .slideLeft:
            centerXAnchor2!.constant += width
            vc.view!.layoutIfNeeded()
            view.layoutIfNeeded()
            centerXAnchor1!.constant -= width
            centerXAnchor2!.constant -= width
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutSubviews()
        }) { _ in
            child.view!.removeFromSuperview()
            child.removeFromParentViewController()
            vc.didMove(toParentViewController: self)
            self.didShow?()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        guard let child = childViewControllers.last else {
            return
        }
        NSLayoutConstraint.deactivate(currentConstraints!)
        extractedFunc(child, newCollection)
        centerXAnchor1 = currentConstraints?.first
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func extractedFunc(_ child: UIViewController, _ newCollection: UITraitCollection) {
        let constraints: [NSLayoutConstraint]
        if newCollection.verticalSizeClass == .regular || newCollection.verticalSizeClass == .unspecified {
            constraints = [
                child.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                child.view!.widthAnchor.constraint(equalTo: view.widthAnchor),
                child.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        } else {
            constraints = [
                child.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                child.view!.widthAnchor.constraint(equalTo: view.heightAnchor),
                child.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        }
        NSLayoutConstraint.activate(constraints)
        currentConstraints = constraints
    }
}
