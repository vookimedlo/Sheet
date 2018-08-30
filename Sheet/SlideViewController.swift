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
    
    private var centerXAnchor1: NSLayoutConstraint!
    private var centerXAnchor2: NSLayoutConstraint!
    
    private func portraitConstraints(_ vc: UIViewController) -> [NSLayoutConstraint] {
        return [
            vc.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vc.view!.widthAnchor.constraint(equalTo: view.widthAnchor),
            vc.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
    
    private func landscapeConstraints(_ vc: UIViewController) -> [NSLayoutConstraint] {
        return [
            vc.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vc.view!.widthAnchor.constraint(equalTo: view.heightAnchor),
            vc.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
    
    override func setupInitialConstraints(_ traitCollection: UITraitCollection) {
        guard let child = childViewControllers.last else {
            return
        }
        let constraints: [NSLayoutConstraint]
        if traitCollection.verticalSizeClass == .regular || traitCollection.verticalSizeClass == .unspecified {
            constraints = portraitConstraints(child)
        } else {
            constraints = landscapeConstraints(child)
        }
        centerXAnchor1 = constraints.first
        NSLayoutConstraint.activate(constraints)
        currentConstraints = constraints
    }
    
    private var currentConstraints: [NSLayoutConstraint]?
    
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
        
        if traitCollection.verticalSizeClass == .regular || traitCollection.verticalSizeClass == .unspecified {
            let constraints = portraitConstraints(vc)
            NSLayoutConstraint.activate(constraints)
            centerXAnchor2 = constraints.first
            currentConstraints = constraints
        } else {
            let constraints = landscapeConstraints(vc)
            NSLayoutConstraint.activate(constraints)
            centerXAnchor2 = constraints.first
            currentConstraints = constraints
        }
        
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
        guard let child = childViewControllers.last else { return }
        NSLayoutConstraint.deactivate(currentConstraints!)
        if newCollection.verticalSizeClass == .regular || newCollection.verticalSizeClass == .unspecified {
            let constraints = portraitConstraints(child)
            NSLayoutConstraint.activate(constraints)
            centerXAnchor1 = constraints.first
            currentConstraints = constraints
        } else {
            let constraints = landscapeConstraints(child)
            NSLayoutConstraint.activate(constraints)
            centerXAnchor1 = constraints.first
            currentConstraints = constraints
        }
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
