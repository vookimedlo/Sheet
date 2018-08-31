import UIKit

final class SlideViewController: ParentViewController {
    
    var animation: Animation = .slideRight
    
    override func setupPrimaryChildConstraints(_ primaryChild: UIViewController, _ traitCollection: UITraitCollection) {
        let constraints = makeConstraints(for: .primary, using: traitCollection)
        NSLayoutConstraint.activate(constraints)
        primaryConstraints = constraints
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        primaryChild!.willMove(toParent: nil)
        addChild(vc) // we now have a secondary child
        view.addSubview(secondaryChild!.view!)
        secondaryChild!.view!.translatesAutoresizingMaskIntoConstraints = false
        let secondaryConstraints = makeConstraints(for: .secondary, using: traitCollection)
        NSLayoutConstraint.activate(secondaryConstraints)
        let width = view.bounds.width
        switch animation {
        case .slideRight:
            secondaryAnchorConstraint.constant -= width
            secondaryChild!.view!.layoutIfNeeded()
            view.layoutIfNeeded()
            primaryAnchorConstraint.constant += width
            secondaryAnchorConstraint.constant += width
        case .slideLeft:
            secondaryAnchorConstraint.constant += width
            secondaryChild!.view!.layoutIfNeeded()
            view.layoutIfNeeded()
            primaryAnchorConstraint.constant -= width
            secondaryAnchorConstraint.constant -= width
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.secondaryChild!.didMove(toParent: self)
            self.primaryChild!.view!.removeFromSuperview()
            self.primaryChild!.removeFromParent() // array popped. secondary becomes primary.
            self.primaryAnchorConstraint = self.secondaryAnchorConstraint // secondary became primary.
            self.primaryConstraints = secondaryConstraints // secondary became primary
            self.didShow?()
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        NSLayoutConstraint.deactivate(primaryConstraints) // there will only be one child at this point
        let constraints = makeConstraints(for: .primary, using: newCollection)
        NSLayoutConstraint.activate(constraints)
        primaryConstraints = constraints
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private enum Child {
        case primary, secondary
    }
    
    private func makeConstraints(for child: Child, using traitCollection: UITraitCollection) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint]
        switch child {
        case .primary:
            constraints = traitCollection.constraints(forChild: primaryChild!.view, inParent: view)
            primaryAnchorConstraint = constraints.first
        case .secondary:
            constraints = traitCollection.constraints(forChild: secondaryChild!.view, inParent: view)
            secondaryAnchorConstraint = constraints.first
        }
        return constraints
    }
    
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
    
    private var primaryAnchorConstraint: NSLayoutConstraint!
    private var secondaryAnchorConstraint: NSLayoutConstraint!
    private var primaryConstraints: [NSLayoutConstraint]!
}

private extension UITraitCollection {
    func constraints(forChild childView: UIView, inParent parentView: UIView) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
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
        constraints.append(childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor))
        return constraints
    }
}
