import UIKit

class DiscoverabilityViewController: AccountStatusViewController {
    
    override func didEstablishCurrentUserAccountIsAvailable() {
        CurrentUser.discoverability { (result) in
            switch result {
            case .success(let status):
                DispatchQueue.main.async { self.handle(success: status) }
            case .failure(let error):
                DispatchQueue.main.async { self.handle(error: error) }
            }
        }
    }
    
    private func handle(success status: ApplicationPermissionStatus) {
        switch status {
        case .granted:
            didEstablishCurrentUserIsDiscoverable()
        case .couldNotComplete(let message):
            couldNotDetermine(message)
        case .denied(let message):
            denied(message)
        case .initialState:
            fatalError("Should be handled by CurrentUser class")
        }
    }
    
    private func handle(error: CloudError?) {
        let error = error.require(hint: "CurrentUser class returned nil error during failure response for call to accountStatus")
        switch error {
        case .incompatibleVersion(let message):
            incompatibleVersion(message)
        case .networkFailure(let message, let seconds):
            networkFailure(message, seconds)
        case .operationCancelled(let message):
            operationCancelled(message)
        case .requestRateLimited(let message, let seconds):
            requestRateLimited(message, seconds)
        case .serverResponseLost(let message):
            serverResponseLost(message)
        case .serviceUnavailable(let message, let seconds):
            serviceUnavailable(message, seconds)
        default:
            unexpected(CloudError.unexpectedErrorMessage)
        }
    }
    
    private func denied(_ message: String) {
        let title = "Look Me Up"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        performSegue(withIdentifier: segueIDFail, sender: package)
    }
    
    func didEstablishCurrentUserIsDiscoverable() {
        fatalError("Must override")
    }
}
