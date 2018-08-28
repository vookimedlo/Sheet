import UIKit

final class CompleteSheetViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            Customiser.customise(iconImageView)
        }
    }
    
    @IBOutlet weak var finishButton: UIButton! {
        didSet {
            Customiser.customise(finishButton)
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .dismiss, object: nil)
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
}
