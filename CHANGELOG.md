[1.0.0](https://github.com/avito-tech/Marshroute/releases/tag/1.0.0)
- В кострукторах `ResettingTransitionContext` параметр `animatingTransitionsHandler` переименован в `navigationTransitionsHandler` там, где мы работаем с `UINavigationController`.
- `AnimatingTransitionsHandler` переименован в `BaseAnimatingTransitionsHandler`, появился протокол `AnimatingTransitionsHandler`.
- `ContainingTransitionsHandler` переименован в `BaseContainingTransitionsHandler`, появился протокол `ContainingTransitionsHandler`.
- Появились протоколы `NavigationTransitionsHandler`, `SplitViewTransitionsHandler`, `TabBarTransitionsHandler` для лучшей типизации кода.
- Вместо прямой завязки на `UITabBarController` и `UISplitViewController` теперь есть протоколы `TabBarControllerProtocol` и `SplitViewControllerProtocol`. Теперь можно работать с Marshroute, подставив кастомные реализации таб бара и сплит вью. Заметка: аналогичную работу можно проделать и для `UINavigationController`'а, но на практике еще не встречалось случаев, когда кто-то реализовывал аналоги навигационного контроллера своими силами.
- Удалены `WeakBox` и `StrongBox`
- Некоторые `marshroutePrint` заменены на `marshrouteAssertionFailure`

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
