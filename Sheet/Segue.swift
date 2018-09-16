import UIKit

open class StoryboardSegue: UIStoryboardSegue {
    
    override open func perform() {
        super.perform()
        executeTransition {
            self.transitionCleanUp()
        }
    }
    
    open func executeTransition(_ completion: @escaping () -> Void) {}
    
    private func transitionCleanUp() {
        let parent = self.destination.parent!
        self.destination.didMove(toParent: parent)
        self.source.view.removeFromSuperview()
        self.source.removeFromParent()
    }
}
