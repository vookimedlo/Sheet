<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Sheet" />
</p>

<p align="center">
    <a href="https://travis-ci.org/rob-nash/Sheet">
        <img src="https://travis-ci.org/rob-nash/Sheet.svg?branch=master" alt="Build"/>
    </a>
    <a href="https://img.shields.io/badge/carthage-compatible-brightgreen.svg">
        <img src="https://img.shields.io/badge/carthage-compatible-brightgreen.svg" alt="Carthage"/>
    </a>
    <a href="https://codebeat.co/projects/github-com-rob-nash-sheet-master">
    	<img alt="codebeat badge" src="https://codebeat.co/badges/94dfa117-7d48-451d-bff9-81117efe5032"/>
    </a>
    <a href="https://twitter.com/nashytitz">
        <img src="https://img.shields.io/badge/contact-@nashytitz-blue.svg?style=flat" alt="Twitter: @nashytitz"/>
    </a>
</p>

A very light-weight action sheet. Responds to size class changes.

## Animations

Fade             |  Slide
:-------------------------:|:-------------------------:
![Fade](https://user-images.githubusercontent.com/14126999/44885530-3dc44400-acb9-11e8-868f-20f8780ad24d.gif)  |  ![Slide](https://user-images.githubusercontent.com/14126999/44885592-94ca1900-acb9-11e8-9f91-2b8ca042cddf.gif)

## iPad

![iPad](https://user-images.githubusercontent.com/14126999/44899553-fca05400-acf9-11e8-878e-de5bcff58c9d.gif)

## Usage

Use the following code to setup an action sheet.

```swift
import UIKit
import Sheet

extension Notification.Name {
    static let dismiss = Notification.Name(rawValue: "Dismiss")
}

class ViewController: UIViewController {

    private let sheetManager = SheetManager(animation: .slideLeft)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetManager.chromeTapped = { [unowned self] in
            self.dismiss(animated: true)
        }
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "WelcomeSheet", bundle: nil).instantiateInitialViewController()!
        sheetManager.show(viewController, above: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
```

You can use a storyboard to build the individual sheets, if you wish. The first sheet in the above gif is named `WelcomeSheetViewController`. It looks like this.

```swift
final class WelcomeSheetViewController: UIViewController {
        
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let viewController = UIStoryboard(name: "CompleteSheet", bundle: nil).instantiateInitialViewController()!
        show(viewController, sender: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.clipsToBounds = true
        view.layer.cornerRadius = view.bounds.width * 0.1
    }
}
```

The second sheet in the above gif is named `CompleteSheetViewController`. It looks like this.

```swift
final class CompleteSheetViewController: UIViewController {
        
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .dismiss, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.clipsToBounds = true
        view.layer.cornerRadius = view.bounds.width * 0.1
    }
}
```

The `viewDidLayoutSubviews` implementation is common between both controllers, so you might want to create a superclass for it.

- [Storyboard Layout](https://github.com/rob-nash/Sheet/wiki/Storyboard-Implementations)
- [Safe Area Insets](https://github.com/rob-nash/Sheet/wiki/Safe-Area-Insets)
- [The Vanishing Paper Plane](https://github.com/rob-nash/Sheet/wiki/Responding-To-Size-Class-Changes)

## Installation

Add the following to your `Cartfile`.

```
github rob-nash/Sheet
```

For the latest release, select the [Releases](https://github.com/rob-nash/Sheet/releases) tab.

## Demo

Run the Xcode scheme named `Sender`.

## Footnote

Try to realise the truth 😎 There is no spoon 🥄

![](https://user-images.githubusercontent.com/14126999/44734588-339c1d00-aae2-11e8-9f50-58b835654fef.gif)

```swift
@IBAction func finishButtonPressed(_ sender: UIButton) {
        let view = UIImageView(image: UIImage(named: "_paper_plane"))
        view.contentMode = .scaleAspectFit
        view.layoutIfNeeded()
        view.isHidden = true
        stackView.insertArrangedSubview(view, at: 0)
        UIView.animate(withDuration: 0.3) {
            view.isHidden = false
        }
//        NotificationCenter.default.post(name: .dismiss, object: nil)
    }
```

![](https://user-images.githubusercontent.com/14126999/45015849-d987e400-b01a-11e8-8437-c97cc62f5c61.png)
