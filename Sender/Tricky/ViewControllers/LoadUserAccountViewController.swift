import UIKit

final class LoadUserAccountViewController: DiscoverabilityViewController {
    
    override func didEstablishCurrentUserIsDiscoverable() {
        performSegue(withIdentifier: segueIDSuccess, sender: nil)
    }
}
