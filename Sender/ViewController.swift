import UIKit
import Sheet

class ViewController: UIViewController {

    private let sheetManager = SheetManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetManager.chromeTapped = { [unowned self] in
            self.dismiss(animated: true)
        }
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { _ in
            self.dismiss(animated: true)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "WelcomeSheet", bundle: nil).instantiateInitialViewController()!
        sheetManager.show(viewController, above: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let dismiss = Notification.Name(rawValue: "Dismiss")
}
