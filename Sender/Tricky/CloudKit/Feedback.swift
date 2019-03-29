import CloudKit

/// The state of permission
///
/// - initialState: The user has not made a decision for this application permission
/// - couldNotComplete: An error occurred when getting or setting the application permission status
/// - denied: The user has denied this application permission
/// - granted: The user has granted this application permission
public enum ApplicationPermissionStatus {
    case initialState, couldNotComplete(String), denied(String), granted
    init?(_ status: CKContainer_Application_PermissionStatus?, message: String? = nil) {
        guard status != nil else {
            return nil
        }
        switch status! {
        case .initialState:
            self = .initialState
        case .couldNotComplete:
            self = .couldNotComplete(CloudError.couldNotDetermine(message))
        case .denied:
            let message = "To share the time with friends, you must allow friends to share the time with you. Visit the settings App and go to your AppleID page where you can navigate to the iCloud menu and select 'look me up'. Only your contacts will be able to do this."
            self = .denied(message)
        case .granted:
            self = .granted
        @unknown default:
            fatalError()
        }
    }
}

/// The status of an account
///
/// - couldNotDetermine: An error occurred when getting the account status
/// - available: The iCloud account credentials are available for this application
/// - restricted: Parental Controls / Device Management has denied access to iCloud account credentials
/// - noAccount: No iCloud account is logged in on this device
public enum AccountStatus {
    case couldNotDetermine(String), available, restricted(String), noAccount(String)
    init?(_ status: CKAccountStatus?, message: String? = nil) {
        guard status != nil else {
            return nil
        }
        switch status! {
        case .couldNotDetermine:
            self = .couldNotDetermine(CloudError.couldNotDetermine(message))
        case .available:
            self = .available
        case .restricted:
            let message = "Your device settings currently block access to iCloud. This could be your parental control settings."
            self = .restricted(message)
        case .noAccount:
            let message = "In the settings App, navigate to the AppleID menu and sign-in to iCloud.\n\nIf you are already signed-in, navigate to the iCloud sub-menu and check this App is listed there as 'enabled'."
            self = .noAccount(message)
        @unknown default:
            fatalError()
        }
    }
}

public enum CloudError: Error, ErrorInitable {
    
    case networkFailure(String, Int)
    case serviceUnavailable(String, Int)
    case incompatibleVersion(String)
    case notAuthenticated(String)
    case permissionFailure
    case operationCancelled(String)
    case requestRateLimited(String, Int)
    case userDeletedZone
    case zoneBusy(Int)
    case zoneNotFound
    case serverResponseLost(String)
    case changeTokenExpired
    case unexpected(String)
    
    init(_ error: CKError) {
        let hint = "Expecting CKError's 'errorCode' property, of which the value is \(error.errorCode), to map to CKError.Code."
        let code = CKError.Code(rawValue: error.errorCode).require(hint: hint)
        switch code {
        case .networkUnavailable:
            let package = CloudError.networkFailurePackage(error)
            let seconds = package.seconds
            let message = package.message
            self = .networkFailure(message, seconds)
        case .serviceUnavailable:
            let seconds = ErrorHelper.secondsDelay(error)
            let message = "The iCloud service is currently unavailable."
            self = .serviceUnavailable(message, seconds)
        case .networkFailure:
            let package = CloudError.networkFailurePackage(error)
            let seconds = package.seconds
            let message = package.message
            self = .networkFailure(message, seconds)
        case .notAuthenticated:
            let message = "Please sign-in to your iCloud account via the Settings app."
            self = .notAuthenticated(message)
        case .permissionFailure:
            self = .permissionFailure
        case .operationCancelled:
            let message = "iCloud quit unexpectedly. Please try again."
            self = .operationCancelled(message)
        case .incompatibleVersion:
            let message = "Please update this App via the AppStore."
            self = .incompatibleVersion(message)
        case .zoneNotFound:
            self = .zoneNotFound
        case .userDeletedZone:
            self = .userDeletedZone
        case .serverResponseLost:
            let message = "The response from iCloud was lost. Please check your signal and try again."
            self = .serverResponseLost(message)
        case .zoneBusy:
            self = .zoneBusy(ErrorHelper.secondsDelay(error))
        case .requestRateLimited:
            let message = "iCloud is under a lot of pressure at the moment."
            let seconds = ErrorHelper.secondsDelay(error)
            self = .requestRateLimited(message, seconds)
        default:
            let message = CloudError.unexpectedErrorMessage
            self = .unexpected(message)
        }
    }
    
    static func couldNotDetermine(_ message: String?) -> String {
        if let message = message {
            return message
        } else {
            return "We couldn't reach your account details and we're not sure why iCloud is failing. Please try again later."
        }
    }
    
    static let unexpectedErrorMessage = "There was an unexpected problem. Please try again later."
    
    private static func networkFailurePackage(_ error: CKError) -> (message: String, seconds: Int) {
        let seconds = ErrorHelper.secondsDelay(error)
        let message: String
        if seconds == 0 {
            message = "Please check your signal."
        } else {
            message = "There is a problem connecting to iCloud."
        }
        return (message, seconds)
    }
}

struct ErrorHelper {
    
    static func secondsDelay(_ error: CKError) -> Int {
        let seconds: Double
        if let number = error.userInfo[CKErrorRetryAfterKey] as? NSNumber {
            seconds = number.doubleValue
        } else {
            seconds = 0
        }
        return Int(seconds.rounded(.up))
    }
}

protocol ErrorInitable {
    init(_ error: CKError)
}

extension ErrorInitable {
    init?(_ error: Error?) {
        guard error != nil else { return nil }
        let error = (error as? CKError).require(hint: "Expecting CKError from CloudKit API. Instead received error of type named " + typeName(error!))
        self.init(error)
    }
}

public enum CompletionResult<T, E: Error> {
    case success(T), failure(E?)
}

public extension CompletionResult {
    init(value: T?, error: E?) {
        switch (value, error) {
        case (let value?, _):
            self = .success(value)
        case (nil, let error):
            self = .failure(error)
        }
    }
}
