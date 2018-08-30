import UIKit

final class FadeViewController: ParentViewController {
    
    override func show(_ vc: UIViewController, sender: Any?) {
        
        let child = childViewControllers.first!
        child.willMove(toParentViewController: nil)
        
        view.addSubview(vc.view!)
        addChildViewController(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        applyConstraints(traitCollection)
        vc.view!.layoutIfNeeded()
        vc.view!.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            child.view!.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            child.view!.removeFromSuperview()
            child.removeFromParentViewController()
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                vc.view!.alpha = 1
            }, completion: { _ in
                vc.didMove(toParentViewController: self)
                self.didShow?()
            })
        })
    }
    
    fileprivate func portraitConstraints(_ vc: UIViewController) -> [NSLayoutConstraint] {
        return [
            vc.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vc.view!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view!.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
    
    fileprivate func landscapeConstraints(_ vc: UIViewController) -> [NSLayoutConstraint] {
        return [
            vc.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vc.view!.widthAnchor.constraint(equalTo: view.heightAnchor),
            vc.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
    }
    
    override func applyConstraints(_ traitCollection: UITraitCollection) {
        guard let child = childViewControllers.last else {
            return
        }
        if traitCollection.verticalSizeClass == .regular || traitCollection.verticalSizeClass == .unspecified {
            NSLayoutConstraint.deactivate(landscapeConstraints(child))
            NSLayoutConstraint.activate(portraitConstraints(child))
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints(child))
            NSLayoutConstraint.activate(landscapeConstraints(child))
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        applyConstraints(newCollection)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
