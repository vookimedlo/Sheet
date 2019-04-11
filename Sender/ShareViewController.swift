import UIKit
import Sheet

class ShareViewController: UIViewController {
    
    private var sheet: Sheet!
    
    var type: ShareType = .simple {
        didSet {
            sheet = type.sheetManager() { [unowned self] in
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var messageLabel: UILabel!
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observer = SheetNotificationObserverFactory.observer() { [weak self] (dismissAnimated, thenShowFriends) in
            let completion: () -> Void = {
                if thenShowFriends {
                    assertionFailure("Not implemented.")
                    // Maybe show a view controller at this point?
                }
            }
            self?.dismiss(animated: dismissAnimated, completion: completion)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let initial = type.loadInitialSheet()
        sheet.show(initial, above: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
