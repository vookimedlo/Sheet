# Change Log

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
