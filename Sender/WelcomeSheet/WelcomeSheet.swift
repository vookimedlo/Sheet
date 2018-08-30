import UIKit

final class WelcomeSheetViewController: UIViewController {
    
    @IBOutlet weak var iconImageViewContainerView: UIView!
    
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
        let viewController = UIStoryboard(name: "CompleteSheet", bundle: nil).instantiateInitialViewController()!
        show(viewController, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iconImageViewContainerView.isHidden = (traitCollection.verticalSizeClass == .compact)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.clipsToBounds = true
        view.layer.cornerRadius = view.bounds.width * 0.1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        iconImageViewContainerView.isHidden = (newCollection.verticalSizeClass == .compact)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
