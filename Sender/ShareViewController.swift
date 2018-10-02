import UIKit
import Sheet

enum ShareType {
    case simple, tricky
}

class ShareViewController: UIViewController {
    
    var type: ShareType = .simple {
        didSet {
            let width: CGFloat = 30
            let bottom: CGFloat = 20
            switch type {
            case .simple:
                sheet = Sheet(animation: .fade, widthInset: width, bottomInset: bottom)
            case .tricky:
                sheet = Sheet(animation: .custom, widthInset: width, bottomInset: bottom)
            }
            sheet.chromeTapped = { [unowned self] in
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var messageLabel: UILabel!
    
    private var sheet: Sheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { [weak self] notification in
            let animated: Bool
            if let info = notification.userInfo, let outcome = info[dismissSheetAnimatedKey] as? Bool {
                animated = outcome
            } else {
                animated = true
            }
            self?.dismiss(animated: animated, completion: {
                if let info = notification.userInfo, let _ = info[showFriendsKey] as? Bool {
                    let controller = UIAlertController(title: "Not Implemented", message: "Maybe show a view controller at this point?", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    controller.addAction(action)
                    self?.present(controller, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        switch type {
        case .simple:
            simple()
        case .tricky:
            tricky()
        }
    }
    
    private func simple() {
        if networkConnectionAvailable {
            let viewController = UIStoryboard(name: "WelcomeSheet", bundle: nil).instantiateInitialViewController()!
            sheet.show(viewController, above: self)
        } else {
            showNetworkProblem()
        }
    }
    
    private func tricky() {
        if networkConnectionAvailable {
            let viewController = UIStoryboard(name: "Sharing", bundle: nil).instantiateInitialViewController()!
            sheet.show(viewController, above: self)
        } else {
            showNetworkProblem()
        }
    }
    
    private func showNetworkProblem() {
        let message = "The internet is required to share the time with friends."
        let viewController = UIStoryboard(name: "NetworkSheet", bundle: nil).instantiateInitialViewController() as! NetworkFailureViewController
        viewController.loadView()
        viewController.insert(message)
        sheet.show(viewController, above: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
