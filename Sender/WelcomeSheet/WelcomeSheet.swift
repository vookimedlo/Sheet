import UIKit

final class WelcomeSheetViewController: BaseViewController {
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            Customiser.customise(iconImageView)
        }
    }
    
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            Customiser.customise(startButton)
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        // when using SheetManager(animation: .custom) && custom segue
        performSegue(withIdentifier: "Custom", sender: self)
        
        // otherwise use this (or remove custom segue from Custom.storyboard)
//        let viewController = UIStoryboard(name: "CompleteSheet", bundle: nil).instantiateInitialViewController()!
//        show(viewController, sender: self)
    }
    
    @IBOutlet weak var iconImageViewContainerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iconImageViewContainerView.isHidden = (traitCollection.verticalSizeClass == .compact)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        iconImageViewContainerView.isHidden = (newCollection.verticalSizeClass == .compact)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
