import UIKit

struct SheetFactory {
    
    static func welcome() -> WelcomeSheetViewController {
        return Sheet.welcome.load()
    }
    
    static func connect() -> ConnectViewController {
        return Sheet.connect.load()
    }
    
    static func network(_ message: String) -> NetworkFailureViewController {
        let viewController = Sheet.network.load() as NetworkFailureViewController
        viewController.loadView()
        viewController.insert(message)
        return viewController
    }
    
    private enum Sheet {
        
        case welcome, sharing, connect, network
        
        func load<T: UIViewController>() -> T {
            return storyboard.instantiateInitialViewController() as! T
        }
        
        private var storyboard: UIStoryboard {
            return UIStoryboard(name: name, bundle: nil)
        }
        
        private var name: String {
            switch self {
            case .welcome:
                return "WelcomeSheet"
            case .sharing, .connect, .network:
                return "Sharing"
            }
        }
    }
}
