[1.0.1](https://github.com/avito-tech/Marshroute/releases/tag/1.0.1)
- Поправлены ложные ассерты об утекших экранах, редко возникающие неверно по причине того, что UIKit промедлил с очисткой экрана из памяти
- В демо приложение добавлена шторка (bottom sheet) на третий таб на айфоне или на detail view сплит контроллера первого таба на айпаде). Проверяется навык Маршрута не закрывать повторно уже закрытые модально экраны (в демке это когда шторку с полочками закрывают свайпом вниз или тапом по затемненной области вокруг шторки, при этом модальный экран первый раз закрывается напрямую через UIKit, а второй раз через Marshroute). Это работает только если второе закрытие вызывается асинхронно от первого (в completion'е первого закрытия экрана)

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