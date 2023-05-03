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
