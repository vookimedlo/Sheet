import UIKit

final class CompleteSheetViewController: BaseViewController {
    
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
}
