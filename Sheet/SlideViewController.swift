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
    
    private var previousConstraints: [NSLayoutConstraint]?
    
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
    
    override func applyConstraints(_ traitCollection: UITraitCollection) {
        guard let child = childViewControllers.last else {
            return
        }
        if traitCollection.verticalSizeClass == .regular || traitCollection.verticalSizeClass == .unspecified {
            let currentConstraints = portraitConstraints(child)
            NSLayoutConstraint.activate(currentConstraints)
        } else {
            let currentConstraints = landscapeConstraints(child)
            NSLayoutConstraint.activate(currentConstraints)
        }
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        
        let child = childViewControllers.last!
        child.willMove(toParentViewController: nil)

        for constraint in child.view!.constraints {
            if let firstItem = constraint.firstItem as? UIView {
                let firstAnchor = constraint.firstAnchor
                let a = firstItem == child.view!
                let b = firstAnchor is NSLayoutAnchor<NSLayoutXAxisAnchor>
                if a && b {
                    centerXAnchor1 = constraint
                    break
                }
            }
        }
        
        view.addSubview(vc.view!)
        addChildViewController(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        
        applyConstraints(traitCollection)
        
        for constraint in vc.view!.constraints {
            if let firstItem = constraint.firstItem as? UIView {
                let firstAnchor = constraint.firstAnchor
                let a = firstItem == vc.view!
                let b = firstAnchor is NSLayoutAnchor<NSLayoutXAxisAnchor>
                if a && b {
                    centerXAnchor2 = constraint
                    break
                }
            }
        }
        
        let width = view.bounds.width
        
        switch animation {
        case .slideRight:
            centerXAnchor2?.constant -= width
            vc.view!.layoutIfNeeded()
            view.layoutIfNeeded()
            centerXAnchor1?.constant += width
            centerXAnchor2?.constant += width
        case .slideLeft:
            centerXAnchor2?.constant += width
            vc.view!.layoutIfNeeded()
            view.layoutIfNeeded()
            centerXAnchor1?.constant -= width
            centerXAnchor2?.constant -= width
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
}
