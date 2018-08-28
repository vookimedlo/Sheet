import UIKit

struct Customiser {
    
    private static let color1 = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    private static let color2 = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    static func customise(_ button: UIButton) {
        let width = button.bounds.width
        let layer = button.layer
        layer.masksToBounds = true
        layer.cornerRadius = width * 0.05
        let bounds = button.bounds
        let normalImage = UIGraphicsImageRenderer(size: bounds.size).image { _ in
            color1.setFill()
            UIRectFill(bounds)
        }
        let highlightedImage = UIGraphicsImageRenderer(size: bounds.size).image { _ in
            color2.setFill()
            UIRectFill(bounds)
        }
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(color1, for: .highlighted)
        button.setBackgroundImage(normalImage, for: .normal)
        button.setBackgroundImage(highlightedImage, for: .highlighted)
    }
    
    static func customise(_ imageView: UIImageView) {
        let width = imageView.bounds.width
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = width * 0.15
    }
}
