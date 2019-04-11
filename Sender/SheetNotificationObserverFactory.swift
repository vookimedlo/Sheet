import Foundation

let dismissSheetAnimatedKey = "keyDismissSheetAnimated"
let showFriendsKey = "keyShowFriends"

extension Notification.Name {
    static let dismiss = Notification.Name(rawValue: "Dismiss")
}

struct SheetNotificationObserverFactory {
    
    /// Creats an observer that listens for a 'sheet has requested dismiss' event.
    ///
    /// - Parameters:
    ///   - center: The handler for notifications.
    ///   - handler: The handler for dismissing a sheet.
    /// - Returns: An observer.
    static func observer(using center: NotificationCenter = .default, with handler: @escaping (Bool, Bool) -> Void) -> NSObjectProtocol {
        return center.addObserver(
            forName: .dismiss,
            object: nil,
            queue: nil,
            using: { notification in
                let animated = (notification.userInfo?[dismissSheetAnimatedKey] as? Bool) ?? false
                let showFriends = (notification.userInfo?[showFriendsKey] as? Bool) ?? false
                handler(animated, showFriends)
        })
    }
}
