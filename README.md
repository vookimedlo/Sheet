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

A very light-weight action sheet.

Fade             |  Slide
:-------------------------:|:-------------------------:
![Demo1](https://user-images.githubusercontent.com/14126999/44732870-31d05a80-aade-11e8-9073-294dfa345cc3.gif)  |  ![Demo2](https://user-images.githubusercontent.com/14126999/44732911-41e83a00-aade-11e8-956f-0b093fb085dd.gif)

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
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { _ in
            self.dismiss(animated: true)
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

You can use a storyboard to build the individual sheets, if you wish. The first sheet in the above gif is `WelcomeSheetViewController`.

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
```

The second sheet in the above gif is `CompleteSheetViewController`.

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
```

The `viewDidLayoutSubviews` implementation is common between both controllers. You could put that code in a superclass implementation if you wish?

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
