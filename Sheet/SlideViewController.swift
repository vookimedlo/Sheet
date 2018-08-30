import UIKit

final class SlideViewController: ParentViewController {
    
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
    
    override func show(_ vc: UIViewController, sender: Any?) {
        go(vc)
    }
        
    private var centerXAnchor1: NSLayoutConstraint!
    private var centerXAnchor2: NSLayoutConstraint!
    
    var animation: Animation = .slideRight
    
    private func go(_ vc: UIViewController) {
        
        vc.modalPresentationCapturesStatusBarAppearance = true
        
        guard let child = children.last else {
            view.addSubview(vc.view!)
            addChild(vc)
            vc.view!.translatesAutoresizingMaskIntoConstraints = false
            centerXAnchor1 = vc.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            NSLayoutConstraint.activate([
                centerXAnchor1!,
                vc.view!.widthAnchor.constraint(equalTo: view.widthAnchor),
                vc.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
            vc.didMove(toParent: self)
            didShow?()
            return
        }
        
        for constraint in child.view!.constraints {
            if let firstItem = constraint.firstItem as? UIView {
                if firstItem == child.view! && constraint.firstAnchor.isEqual(centerXAnchor2) {
                    centerXAnchor1 = centerXAnchor2
                    break
                }
            }
        }
        
        child.willMove(toParent: nil)
        
        view.addSubview(vc.view!)
        addChild(vc)
        vc.view!.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor2 = vc.view!.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([
            centerXAnchor2,
            vc.view!.widthAnchor.constraint(equalTo: view.widthAnchor),
            vc.view!.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
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
            child.removeFromParent()
            vc.didMove(toParent: self)
            self.didShow?()
        }
    }
}
