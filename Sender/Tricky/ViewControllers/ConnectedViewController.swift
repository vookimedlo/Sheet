import UIKit

final class ConnectedViewController: StandardSheetViewController {
    
    private enum ButtonType: Int {
        case showFriends = 0
        case hide = 1
    }
    
    override func actionButtonPressed(_ sender: UIButton) {
        switch ButtonType(rawValue: sender.tag).require() {
        case .showFriends:
            NotificationCenter.default.post(name: .dismiss, object: self, userInfo: [showFriendsKey : true])
        case .hide:
            performSegue(withIdentifier: "Hide", sender: self)
        }
    }
}
