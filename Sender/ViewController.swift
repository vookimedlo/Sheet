import UIKit
import Sheet

class ViewController: UIViewController {

    private let sheetManager = Sheet(animation: .custom, widthInset: 30, bottomInset: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetManager.chromeTapped = { [unowned self] in
            self.dismiss(animated: true)
        }
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { [weak self] notification in
            let animated: Bool
            if let info = notification.userInfo, let outcome = info[dismissSheetAnimatedKey] as? Bool {
                animated = outcome
            } else {
                animated = true
            }
            self?.dismiss(animated: animated)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        
        // when using Sheet(animation: .custom) && custom segue
        // also look at notes in WelcomeSheetViewController
        let viewController = UIStoryboard(name: "Custom", bundle: nil).instantiateInitialViewController()!
        sheetManager.show(viewController, above: self)
        
        // otherwise use this (or remove custom segue from Custom.storyboard)
//        let viewController = UIStoryboard(name: "WelcomeSheet", bundle: nil).instantiateInitialViewController()!
//        sheetManager.show(viewController, above: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let dismiss = Notification.Name(rawValue: "Dismiss")
}
