struct NavigationTransitionStorableParameters: TransitionStorableParameters {
    /// если показывать модально UITabBarController или UISplitViewController,
    /// то кто-то должен держать сильную ссылку на его обработчика переходов.
    /// в то время как роутеры дочерних контроллеров показываемого контроллера 
    /// будут держать сильные ссылки на свои обработчики переходов
    let presentedTransitionsHandler: TransitionsHandler
}