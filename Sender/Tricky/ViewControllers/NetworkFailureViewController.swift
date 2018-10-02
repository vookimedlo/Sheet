import UIKit

final class NetworkFailureViewController: UIViewController {
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    func insert(_ message: String) {
        messageLabel.text = message
    }
}
