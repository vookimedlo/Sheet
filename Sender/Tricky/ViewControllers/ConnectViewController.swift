import UIKit

final class ConnectViewController: StandardSheetViewController {
    
    override func actionButtonPressed(_ sender: UIButton) {
        if networkConnectionAvailable {
            performSegue(withIdentifier: "Connecting", sender: self)
        } else {
            performSegue(withIdentifier: "Network", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Network" {
            let controller = segue.destination as! NetworkFailureViewController
            controller.loadViewIfNeeded()
            let message = "The internet is needed to share with friends."
            controller.insert(message)
        }
    }
}
