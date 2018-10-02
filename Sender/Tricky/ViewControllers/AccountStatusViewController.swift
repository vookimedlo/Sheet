import UIKit

class AccountStatusViewController: ContactingViewController {
    
    override func didFinishAnimation() {
        CurrentUser.account { [weak self] (result) in
            switch result {
            case .success(let status):
                DispatchQueue.main.async { self?.handle(success: status) }
            case .failure(let error):
                DispatchQueue.main.async { self?.handle(error: error) }
            }
        }
    }
    
    private func handle(success status: AccountStatus) {
        switch status {
        case .available:
            didEstablishCurrentUserAccountIsAvailable()
        case .couldNotDetermine(let message):
            couldNotDetermine(message)
        case .noAccount(let message):
            noAccount(message)
        case .restricted(let message):
            restricted(message)
        }
    }
    
    private func handle(error: CloudError?) {
        let error = error.require(hint: "CurrentUser class returned nil error during failure response for call to accountStatus")
        switch error {
        case .incompatibleVersion(let message):
            incompatibleVersion(message)
        case .networkFailure(let message, let seconds):
            networkFailure(message, seconds)
        case .notAuthenticated(let message):
            notAuthenticated(message)
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
    
    // MARK: Success
    
    func didEstablishCurrentUserAccountIsAvailable() {
        fatalError("Must override")
    }
    
    func couldNotDetermine(_ message: String) {
        let title = "Could Not Determine"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    private func noAccount(_ message: String) {
        let title = "No Account"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    private func restricted(_ message: String) {
        let title = "Restricted"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    // MARK: Error
    
    func incompatibleVersion(_ message: String) {
        let title = "Incompatible Version"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    func networkFailure(_ message: String, _ seconds: Int) {
        let title = "Network Failure"
        let type: ProblemViewController.ProblemType = .error
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    private func notAuthenticated(_ message: String) {
        let title = "Not Authenticated"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    func operationCancelled(_ message: String) {
        let title = "Operation Cancelled"
        let type: ProblemViewController.ProblemType = .awkward
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    func requestRateLimited(_ message: String, _ seconds: Int) {
        let title = "Rate Limited"
        let type: ProblemViewController.ProblemType = .awkward
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    func serverResponseLost(_ message: String) {
        let title = "Response Lost"
        let type: ProblemViewController.ProblemType = .error
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    func serviceUnavailable(_ message: String, _ seconds: Int) {
        let title = "Service Unavailable"
        let type: ProblemViewController.ProblemType = .awkward
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    func unexpected(_ message: String) {
        let title = "Unexpected"
        let type: ProblemViewController.ProblemType = .error
        let seconds: Int? = nil
        let package: Package = (message, title, type, seconds)
        outcomeFailed(package)
    }
    
    private func outcomeFailed(_ package: Package) {
        performSegue(withIdentifier: segueIDFail, sender: package)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIDFail {
            let package = (sender as? Package).require(hint: "Expecting Package")
            let title = package.title
            let message = package.message
            let seconds = package.seconds
            let type = package.type
            let controller = (segue.destination as? ProblemViewController).require(hint: "Expecting ProblemViewController")
            controller.setup(title: title, message: message, type: type, delay: seconds)
        }
    }
}
