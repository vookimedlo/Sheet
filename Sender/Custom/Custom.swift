import UIKit
import Sheet

final class CustomSegue: StoryboardSegue {
    
    override func executeTransition(_ completion: @escaping () -> Void) {
        UIView.transition(
            from: source.view!,
            to: destination.view!,
            duration: 0.3,
            options: [.transitionFlipFromLeft]) { (_) in
                completion()
            }
    }
}
