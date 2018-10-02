import CloudKit

//https://crunchybagel.com/simulating-cloudkit-errors/

class ContainerSimulator {
    
    /// The frequency that a simulated error will occur (0-1)
    private var simulateErrorRate: Float = 1
    
    /// How long to wait before returning a simulated error
    private let simulateErrorDelay: TimeInterval = 1
    
    /// The types of errors that can be simulated
    private let simulateErrorsPossibleCodes: [CKError.Code] = [
        .networkFailure,
        .serviceUnavailable,
        .networkUnavailable,
        .incompatibleVersion,
        .requestRateLimited,
        .operationCancelled,
        .serverResponseLost,
        .zoneNotFound
    ]
    
    init() {
        // do nothing
    }
    
    init(_ container: CKContainer) {
        // do nothing
    }
    
    /// Used for delaying simulated errors
    private func delay(_ delay: TimeInterval, _ closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    func accountStatus(completionHandler: @escaping (CKAccountStatus?, Error?) -> Void) {
        if shouldThrowError() {
            self.delay(self.simulateErrorDelay) {
                completionHandler(nil, self.createRandomError())
            }
        }
        else {
            completionHandler(.noAccount, nil)
        }
    }
    
    func status(forApplicationPermission applicationPermission: CKContainer_Application_Permissions, completionHandler: @escaping (CKContainer_Application_PermissionStatus?, Error?) -> Void) {
        if shouldThrowError() {
            self.delay(self.simulateErrorDelay) {
                completionHandler(nil, self.createRandomError())
            }
        }
        else {
            completionHandler(.granted, nil)
        }
    }
    
    func requestApplicationPermission(_ applicationPermission: CKContainer_Application_Permissions, completionHandler: @escaping (CKContainer_Application_PermissionStatus?, Error?) -> Void) {
        if shouldThrowError() {
            self.delay(self.simulateErrorDelay) {
                completionHandler(nil, self.createRandomError())
            }
        }
        else {
            completionHandler(.granted, self.createRandomError())
        }
    }
}

extension ContainerSimulator {
    
    func enableSimulatedErrors(errorRate: Float) {
        self.simulateErrorRate = max(0, min(1, errorRate))
    }
    
    private func shouldThrowError() -> Bool {
        guard self.simulateErrorRate > 0 else {
            return false
        }
        
        let rand = Float(arc4random()) / Float(UInt32.max)
        return rand < self.simulateErrorRate
    }
    
    fileprivate func createRandomError(_ additionalCodes: [CKError.Code] = []) -> CKError {
        let errors: [CKError.Code] = simulateErrorsPossibleCodes + additionalCodes
        let error = createError(code: errors.randomElement()!)
        return error
    }
    
    fileprivate func createError(code: CKError.Code) -> CKError {
        let error = NSError(domain: CKErrorDomain, code: code.rawValue, userInfo: [CKErrorRetryAfterKey: NSNumber(value: 3)])
        return CKError(_nsError: error)
    }
}
