import Foundation

/// используется в случае, когда обработчик навигационных переходов 
/// заключен в содержащий обработчик переходов (SplitTransitionsHandler).
/// содержащий обработчик переходов занимается только прокидыванием вызовов
/// в один из содержащихся на нем обработчиков навигационных переходов.
/// если один из обработчиков навигационных переходов показал модальное окно или поповер,
/// то прокидывать сообщения нужно именно этому обработчику переходов
protocol NavigationTransitionsHandlerDelegate: class {
    func navigationTransitionsHandlerDidBecomeFirstResponder(handler: NavigationTransitionsHandler)
    func navigationTransitionsHandlerDidResignFirstResponder(handler: NavigationTransitionsHandler)
}
