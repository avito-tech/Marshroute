struct NavigationTransitionStorableParameters: TransitionStorableParameters {
    /// если показывать модально UITabBarController или UISplitViewController,
    /// или  UINavigationController, то кто-то должен держать сильную ссылку 
    /// на соответствующего обработчика переходов.
    /// роутеры держат слабые ссылки на свои обработчики переходов
    let presentedTransitionsHandler: TransitionsHandler
}
