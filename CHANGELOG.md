[1.0.1](https://github.com/avito-tech/Marshroute/releases/tag/1.0.1)
- Fixed falsepositive assertions on view controller retain cycles. They are falsepositive in rare cases when UIKit clears screen memory with a delay
- Added bottom sheet example in a demo app (third tab on iphone and detail view of split view of a first tab on ipad). This helps us to to test Marshroute's feature not to dismiss a modal screen if it is already dismissed. In a demo this is a case when a Shelf module is opened via a bottom sheet and then dismissed via a swipe down gesture or via a tap on a dimmed area around the bottom sheet. In a demo this first dismissal is invoked via UIKit directly and second one is invoked using Marshroute. This Marshroute's feature works only if second dismissal is triggered asynchronously from the first one (i.e. in a completion block of a first dismissal)

[1.0.0](https://github.com/avito-tech/Marshroute/releases/tag/1.0.0)
- In `ResettingTransitionContext` initializers the parameter `animatingTransitionsHandler` was renamed into `navigationTransitionsHandler` in places where we work with `UINavigationController`.
- `AnimatingTransitionsHandler` was renamed into `BaseAnimatingTransitionsHandler` and `AnimatingTransitionsHandler` became a protocol.
- `ContainingTransitionsHandler` was renamed into в `BaseContainingTransitionsHandler` and `ContainingTransitionsHandler` became a protocol.
- Got new `NavigationTransitionsHandler`, `SplitViewTransitionsHandler`, `TabBarTransitionsHandler` protocols for cleaner code.
- Instead of using `UITabBarController` и `UISplitViewController` directly Marshroute now relies on `TabBarControllerProtocol` и `SplitViewControllerProtocol` protocols. That allows you to use a custom tab bar or a split view controller (which can not even inherit from `UITabBarController` or `UISplitViewController`). Note: we can do the same job for `UINavigationController`, but this has never been required so far.
- Removed `WeakBox` и `StrongBox`.
- Some `marshroutePrint` were replaced by `marshrouteAssertionFailure`
- Travis CI was removed
- tv os 9.0 is now supported

[0.5.0](https://github.com/avito-tech/Marshroute/releases/tag/0.4.5)
- Add tvos support. Bump minimum supported ios version to 9.0. Add ability to cancel transition undoing if another transition is in progress (enabled by default). Clean some warnings. 

[0.4.5](https://github.com/avito-tech/Marshroute/releases/tag/0.4.5)
- Fix bugs of the previous version. Write complex unit tests. Remove `marshrouteDebugPrint` function

[0.4.4](https://github.com/avito-tech/Marshroute/releases/tag/0.4.4)
- Support asserting on view controller retain cycles

[0.4.3](https://github.com/avito-tech/Marshroute/releases/tag/0.4.3)
- Migrate to Swift 4.2

[0.4.2](https://github.com/avito-tech/Marshroute/releases/tag/0.4.2)
- Migrate to Swift 4

[0.4.1](https://github.com/avito-tech/Marshroute/releases/tag/0.4.1)
- Fix 3d touch on iOS 11

[0.4.0](https://github.com/avito-tech/Marshroute/releases/tag/0.4.0)
- Support 3d touch (peek and pop)

[0.3.6](https://github.com/avito-tech/Marshroute/releases/tag/0.3.6)
- Fix folder names for issue [#6](https://github.com/avito-tech/Marshroute/issues/6)

[0.3.5](https://github.com/avito-tech/Marshroute/releases/tag/0.3.5)
- Fix Carthage support

[0.3.4](https://github.com/avito-tech/Marshroute/releases/tag/0.3.4)
- Migrate to Swift 3
