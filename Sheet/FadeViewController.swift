import UIKit

final class FadeViewController: ParentViewController {
    
    override func setupPrimaryChildConstraints(_ primaryChild: UIViewController, _ traitCollection: UITraitCollection) {
        let constraints = traitCollection.constraints(forChild: primaryChild.view, inParent: view)
        NSLayoutConstraint.activate(constraints)
        primaryConstraints = constraints
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        primaryChild!.willMove(toParentViewController: nil)
        addChildViewController(vc) // we now have a secondary child
        view.addSubview(secondaryChild!.view!)
        secondaryChild!.view!.translatesAutoresizingMaskIntoConstraints = false
        secondaryChild!.view!.alpha = 0
        let secondaryConstraints = traitCollection.constraints(forChild: secondaryChild!.view, inParent: view)
        NSLayoutConstraint.activate(secondaryConstraints)
        secondaryChild!.view!.layoutIfNeeded()
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.primaryChild!.view!.alpha = 0
        }, completion: { (_) in
            self.primaryChild!.view!.removeFromSuperview()
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                self.secondaryChild!.view!.alpha = 1
            }, completion: { _ in
                self.secondaryChild!.didMove(toParentViewController: self)
                self.primaryChild!.removeFromParentViewController() // array popped. secondary becomes primary.
                self.primaryConstraints = secondaryConstraints // secondary became primary
                self.didShow?()
            })
        })
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        NSLayoutConstraint.deactivate(primaryConstraints)
        let constraints = newCollection.constraints(forChild: primaryChild!.view, inParent: view)
        NSLayoutConstraint.activate(constraints)
        primaryConstraints = constraints
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private var primaryConstraints: [NSLayoutConstraint]!
}

private extension UITraitCollection {
    func constraints(forChild childView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor))
        constraints.append(childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor))
        if verticalSizeClass == .regular || verticalSizeClass == .unspecified {
            let constraint = childView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
            constraint.priority = .defaultHigh
            constraints.append(constraint)
            let views: [String : Any] = ["childView" : childView]
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "[childView(<=414@1000)]", options: [], metrics: nil, views: views))
        } else {
            constraints.append(childView.widthAnchor.constraint(equalTo: parentView.heightAnchor))
        }
        return constraints
    }
}
