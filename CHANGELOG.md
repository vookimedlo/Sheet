# Change Log

## [4.0.0](https://github.com/rob-nash/Sheet/releases/tag/4.0.0) (2018-Sep-28)

 - Renamed `SheetManager` to `Sheet`.
 - Sheet can now be inset with padding.

```swift
@available(*, unavailable, renamed: "Sheet")
public final class SheetManager {}
```

## [3.0.0](https://github.com/rob-nash/Sheet/releases/tag/3.0.0) (2018-Sep-16)

- Custom transitions now available.
- Swift 4.2
- All previous depracated functions are now unavailable.

## [2.2.2](https://github.com/rob-nash/Sheet/releases/tag/2.2.2) (2018-Sep-06)

- Fixed: GitHub issue [#2](https://github.com/rob-nash/Sheet/issues/2). UI pushes beyond view port on 4 inch devices.

## [2.2.1](https://github.com/rob-nash/Sheet/releases/tag/2.2.1) (2018-Aug-31)

- Fixed: The framework target `CFBundleShortVersionString` assignment was not bumped to reflect the current release.

## [2.2.0](https://github.com/rob-nash/Sheet/releases/tag/2.2.0) (2018-Aug-31)

- Width of sheet capped at 414 points. The largests non-iPad devices are 414 points in width.

## [2.1.0](https://github.com/rob-nash/Sheet/releases/tag/2.1.0) (2018-Aug-31)

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
