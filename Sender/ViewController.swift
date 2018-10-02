import UIKit
import Sheet

class ViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = (segue.destination as? ShareViewController).require()
        if segue.identifier == "Simple" {
            controller.type = .simple
        } else if segue.identifier == "Tricky" {
            controller.type = .tricky
        }
    }
}
