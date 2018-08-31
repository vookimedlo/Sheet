# Change Log

## [2.2.0]() (2018-Aug-31)

- Width of sheet capped at 414 points. The largests non-iPad devices are 414 points in width.

## [2.1.0]() (2018-Aug-31)

- Now supports device rotation by responding to `traitCollection.verticalSizeClass` changes.

## [2.0.0](https://github.com/rob-nash/Sheet/releases/tag/2.0.0) (2018-Aug-30)

- Deprecated `present` function.

```swift
@available(*, deprecated: 2.0.0, renamed: "show(above:)")
public func present(_ viewController: UIViewController)
```

- Deprecated `init` function.

```swift
@available(*, deprecated: 2.0.0, renamed: "init(animation:)")
public init(root: UIViewController, animation: Animation = .slideRight)
```

## [1.0.0](https://github.com/rob-nash/Sheet/releases/tag/1.0.0) (2018-Aug-28)

- First release
