import Foundation

func assertPossibleRetainCycle(ofViewController viewController: UIViewController?) {
    if viewController == nil { return }
    
    // Добавляем задержку в 1 секунду на всякий случай, чтобы точно дать UIKit'у очистить память.
    // Если даже через 1 секунду UIKit не очистил память от закрытого экрана, то, вероятно, он утек.
    //
    // Пример из демо приложения на модуле Shelf.
    // Когда экран Shelf открывается внутри шторки (BottomSheet), а закрывается через свайп шторки вниз
    // или через тап по затемнению вокруг шторки, то мы закрываем экран Shelf не через Marshroute,
    // а напрямую через UIKit вызовом `-[UIViewController dismissViewControllerAnimated:completion:]`.
    // Если с completion'е анимации сокрытия шторки закрыть Shelf повторно вызовом Marshroute, то Marshroute
    // разберется, что экран уже закрыт (через логику `isDescribingScreenThatWasAlreadyDismissedWithoutInvokingMarshroute`).
    // Однако, в этот момент сам модуль Shelf будет еще в памяти (UIKit его до сих пор не очистит, непонятно почему).
    // Поэтому даем UIKit'у время на очистку и откладываем проверку перед ассертом.
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak viewController] in
        if let viewController {
            marshrouteAssertionFailure(
                """
                It looks like \(viewController as Any) did not deallocate due to some retain cycle!
                """
            )
        }
    }
}
