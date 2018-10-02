import CloudKit

struct CurrentUser {
    
    private struct Discoverable {
        
        static func status(_ completion: @escaping (CompletionResult<ApplicationPermissionStatus, CloudError>) -> Void) {
            let container = ContainerSimulator()
            container.status(forApplicationPermission: .userDiscoverability) { completion(parse($0, $1)) }
        }
        
        static func request(_ completion: @escaping (CompletionResult<ApplicationPermissionStatus, CloudError>) -> Void) {
            let container = ContainerSimulator()
            container.requestApplicationPermission(.userDiscoverability) { completion(parse($0, $1)) }
        }
        
        private static var parse: (CKContainer_Application_PermissionStatus?, Error?) -> CompletionResult<ApplicationPermissionStatus, CloudError> {
            return { status, error in
                let description = (error as? CKError)?.localizedDescription
                let error = CloudError(error)
                let status = ApplicationPermissionStatus(status, message: description)
                return CompletionResult(value: status, error: error)
            }
        }
    }
    
    static func account(_ completion: @escaping (CompletionResult<AccountStatus, CloudError>) -> Void) {
        let container = ContainerSimulator()
        container.accountStatus { (status, error) in
            let description = (error as? CKError)?.localizedDescription
            let status = AccountStatus(status, message: description)
            let error = CloudError(error)
            let result = CompletionResult(value: status, error: error)
            completion(result)
        }
    }
    
    static func discoverability(_ completion: @escaping (CompletionResult<ApplicationPermissionStatus, CloudError>) -> Void) {
        Discoverable.status { (result) in
            if case .success(let status) = result {
                if case .initialState = status {
                    Discoverable.request(completion)
                    return
                }
            }
            completion(result)
        }
    }
}
