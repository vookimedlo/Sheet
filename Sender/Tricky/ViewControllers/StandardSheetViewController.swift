import UIKit

class StandardSheetViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet var actionButtons: [UIButton]! {
        didSet {
            actionButtons.forEach { (button) in
                Customiser.customise(button)
            }
        }
    }
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            Customiser.customise(iconImageView)
        }
    }
    
    @IBOutlet var iconImageContainerView: UIView!
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iconImageContainerView.isHidden = traitCollection.verticalSizeClass == .compact
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        iconImageContainerView.isHidden = newCollection.verticalSizeClass == .compact
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
