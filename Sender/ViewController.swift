import UIKit
import Sheet

extension Notification.Name {
    static let dismiss = Notification.Name(rawValue: "Dismiss")
}

class ViewController: UIViewController {

    private var sheetManager: SheetManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetManager = SheetManager(root: self, animation: .slideLeft)
        sheetManager?.chromeTapped = { [unowned self] in
            self.dismiss(animated: true)
        }
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { _ in
            self.dismiss(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "WelcomeSheet", bundle: nil).instantiateInitialViewController()!
        sheetManager?.present(viewController)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
