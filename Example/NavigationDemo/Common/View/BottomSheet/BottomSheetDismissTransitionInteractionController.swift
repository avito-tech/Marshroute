import UIKit

// Кажется, этот класс либо сломан полностью, либо частично
// https://mt.avito.ru/avito/pl/u5gaqs8yfffixr95c1go8ipozw
// Вероятно, когда-то закрытие шторок делали через UIPercentDrivenInteractiveTransition,
// но потом переделали через pan gesture и до конца не выпилили старый подход.
// Выяснил это, обнаружив, что dismissCompletion не используется (выпилил его, добавив этот коммент),
// а finishInteractiveDismissTransition не вызывается
final class BottomSheetDismissTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Properties -
    private(set) var isTransitionInProgress = false
    private(set) var isDismissInProgress = false
    private let bottomSheetTransitionDismissAnimator: BottomSheetTransitionDismissAnimator
    
    // MARK: - Init -
    init(bottomSheetTransitionDismissAnimator: BottomSheetTransitionDismissAnimator) {
        self.bottomSheetTransitionDismissAnimator = bottomSheetTransitionDismissAnimator
    }
    
    // MARK: - UIPercentDrivenInteractiveTransition -
    func startInteractiveDismissTransition(withViewController viewController: UIViewController) {
        guard !isTransitionInProgress else { return }
        
        isTransitionInProgress = true
        isDismissInProgress = true
        bottomSheetTransitionDismissAnimator.useLinearAnimation = true
        
        viewController.dismiss(
            animated: true,
            completion: { [weak self] in
                self?.bottomSheetTransitionDismissAnimator.useLinearAnimation = false
                self?.isDismissInProgress = false
            }
        )
    }
    
    func finishInteractiveDismissTransition(withViewController viewController: UIViewController, completion: (() -> ())?) {
        viewController.dismiss(animated: true, completion: completion)
    }
}
