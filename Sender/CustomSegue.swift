import UIKit
import Sheet

final class FlipFromRightSegue: StoryboardSegue {
    
    override func executeTransition(_ completion: @escaping () -> Void) {
        UIView.transition(
            from: source.view,
            to: destination.view,
            duration: 0.3,
            options: [.transitionFlipFromRight]) { _ in
                completion()
        }
    }
}

final class FlipFromLeftSegue: StoryboardSegue {
    
    override func executeTransition(_ completion: @escaping () -> Void) {
        UIView.transition(
            from: source.view,
            to: destination.view,
            duration: 0.3,
            options: [.transitionFlipFromLeft]) { _ in
                completion()
            }
    }
}

final class DropSegue: StoryboardSegue {
    
    override func executeTransition(_ completion: @escaping () -> Void) {
        self.destination.view.layoutIfNeeded()
        self.destination.view.transform = CGAffineTransform(translationX: 0, y: self.destination.view.bounds.height)
        let height = self.source.view.bounds.height
        UIView.animate(withDuration: 0.15, animations: {
            self.source.view.transform = CGAffineTransform(translationX: 0, y: height)
            self.destination.view.transform = CGAffineTransform.identity
        }) { _ in
            completion()
        }
    }
    
}
