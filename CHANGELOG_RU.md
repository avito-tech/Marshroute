[1.0.0](https://github.com/avito-tech/Marshroute/releases/tag/1.0.0)
- В конструкторах `ResettingTransitionContext` параметр `animatingTransitionsHandler` переименован в `navigationTransitionsHandler` там, где мы работаем с `UINavigationController`.
- `AnimatingTransitionsHandler` переименован в `BaseAnimatingTransitionsHandler`, появился протокол `AnimatingTransitionsHandler`.
- `ContainingTransitionsHandler` переименован в `BaseContainingTransitionsHandler`, появился протокол `ContainingTransitionsHandler`.
- Появились протоколы `NavigationTransitionsHandler`, `SplitViewTransitionsHandler`, `TabBarTransitionsHandler` для лучшей типизации кода.
- Вместо прямой завязки на `UITabBarController` и `UISplitViewController` теперь есть протоколы `TabBarControllerProtocol` и `SplitViewControllerProtocol`. Теперь можно работать с Marshroute, подставив кастомные реализации таб бара и сплит вью (которые даже не наследуются от `UITabBarController` и `UISplitViewController`). Заметка: аналогичную работу можно проделать и для `UINavigationController`'а, но на практике еще не встречалось случаев, когда кто-то реализовывал аналоги навигационного контроллера своими силами.
- Удалены `WeakBox` и `StrongBox`
- Некоторые `marshroutePrint` заменены на `marshrouteAssertionFailure`
- Удалена интеграция с Travis
- Поддержана tv os 9.0