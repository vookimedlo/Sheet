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

A very light-weight action sheet (version 1.0.0 has 414 lines of code). There is close to zero configuration options because you are expected to build the UI.

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

    private var sheetManager: SheetManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetManager = SheetManager(root: self, animation: .slideLeft)
        sheetManager?.chromeTapped = { [unowned self] in
            self.dismiss(animated: true)
        }
        NotificationCenter.default.addObserver(forName: .dismiss, object: nil, queue: nil) { _ in
            self.dismiss(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "WelcomeSheet", bundle: nil).instantiateInitialViewController()!
        sheetManager?.present(viewController)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

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

## Installation

Add the following to your `Cartfile`.

```
github rob-nash/Sheet
```

For the latest release, select the [Releases](https://github.com/rob-nash/Sheet/releases) tab.

## Demo

Run the Xcode scheme named `Sender`.
