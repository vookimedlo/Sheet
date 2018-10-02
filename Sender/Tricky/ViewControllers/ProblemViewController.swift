import UIKit

class ProblemViewController: StandardSheetViewController {
    
    enum ProblemType {
        case error, awkward
        var backgroundColor: UIColor {
            switch self {
            case .awkward:
                return #colorLiteral(red: 0.06666666667, green: 0.2235294118, blue: 0.3921568627, alpha: 1)
            case .error:
                return #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
            }
        }
        var icon: UIImage {
            switch self {
            case .awkward:
                return UIImage(named: "_awkward").require()
            case .error:
                return UIImage(named: "_worried").require()
            }
        }
    }
    
    private var type: ProblemType = .awkward
    
    var titleText: String!
    var message: String!
    var delay: Int?
    
    func setup(title: String, message: String, type: ProblemType = .awkward, delay: Int? = nil) {
        self.titleText = title
        self.message = message
        self.type = type
        self.delay = delay
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleText
        view.backgroundColor = type.backgroundColor
        self.iconImageView.image = type.icon
        if let delay = delay, delay > 0 {
            let selector = #selector(updateMessage(_:))
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: selector, userInfo: nil, repeats: true)
            messageLabel.attributedText = generateMessage(delay: delay)
        } else {
            messageLabel.text = message
        }
    }
    
    private func generateMessage(delay: Int) -> NSAttributedString {
        let value = NSMutableAttributedString(string: "").normal(message).normal(" ")
        value.append(delayMessage(delay))
        return NSAttributedString(attributedString: value)
    }
    
    private func delayMessage(_ delay: Int) -> NSAttributedString {
        let word = (delay == 1) ? "second" : "seconds"
        let value = NSMutableAttributedString(string: "").normal("iCloud suggested we ").bold("try again in \(delay) \(word).")
        return NSAttributedString(attributedString: value)
    }
    
    @objc private func updateMessage(_ sender: Timer) {
        delay! -= 1
        if delay! == 0 {
            sender.invalidate()
            performSegue(withIdentifier: "Contacting", sender: self)
        } else {
            messageLabel.attributedText = generateMessage(delay: delay!)
        }
    }
}
