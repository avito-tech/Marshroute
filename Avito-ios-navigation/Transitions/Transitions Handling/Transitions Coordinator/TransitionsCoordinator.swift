import UIKit

/// Протокол описывает передачу обработки и отмены переходов в центр управления переходами
public protocol TransitionsCoordinator: class {
    func coordinatePerformingTransition(
        context context: PresentationTransitionContext,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinatePerformingTransition(
        context context: PresentationTransitionContext,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    
    func coordinateUndoingAllChainedTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateUndoingAllTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateResettingWithTransition(
        context context: ResettingTransitionContext,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
}

// MARK: - TransitionsCoordinator Default Impl
extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    public func coordinatePerformingTransition(
        context context: PresentationTransitionContext,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        // ищем самого глубокого дочернего видимого анимирующего обработчика, чтобы прокинуть ему обработку перехода
        let animatingTransitionsHandler = deepestChainedAnimatingTransitionsHandler(
            forTransitionsHandlers: [transitionsHandler],
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // продолжаем искать среди видимых анимирующих обработчиков (чтобы пользователь видел анимацию)
                return containingTransitionsHandler.visibleTransitionsHandlers
            }
        )
        
        initiatePerformingTransition(
            context: context,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
    
    public func coordinatePerformingTransition(
        context context: PresentationTransitionContext,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        // среди видимых анимирующих обработчиков (то есть в выбранном tab'e tabbar'a)
        let animatingTransitionsHandlers = transitionsHandler.visibleTransitionsHandlers
        
        // выбираем из найденных анимирующих обработчиков один с самым глубоким дочерним анимирующим обработчиком
        // и получаем этого дочернего обработчика, чтобы прокинуть ему обработку перехода
        let animatingTransitionsHandler = deepestChainedAnimatingTransitionsHandler(
            forTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // продолжаем искать среди видимых анимирующих обработчиков (чтобы пользователь видел анимацию)
                return containingTransitionsHandler.visibleTransitionsHandlers
            }
        )

        initiatePerformingTransition(
            context: context,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
    
    public func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        // среди всех анимирующих обработчиков (то есть среди всех tab'ов tabbar'a)
        coordinateUndoingTransitionsImpl(
            afterTransitionId: transitionId,
            includingTransitionWithId: false,
            forTransitionsHandlers: [transitionsHandler],
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // будем искать среди всех анимирующих обработчиков, потому что отмена перехода
                // может случитсья на невидимом экране (из-за анимаций, например)
                return containingTransitionsHandler.allTransitionsHandlers
            }
        )
    }
    
    public func coordinateUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        // среди всех анимирующих обработчиков (то есть среди всех tab'ов tabbar'a)
        guard let animatingTransitionsHandlers = transitionsHandler.allTransitionsHandlers
            else { return }
            
        coordinateUndoingTransitionsImpl(
            afterTransitionId: transitionId,
            includingTransitionWithId: false,
            forTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // продолжаем искать среди всех анимирующих обработчиков, потому что отмена перехода
                // может случитсья на невидимом экране (из-за анимаций, например)
                return containingTransitionsHandler.allTransitionsHandlers
            }
        )
    }
    
    public func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        // среди всех анимирующих обработчиков (то есть среди всех tab'ов tabbar'a)
        coordinateUndoingTransitionsImpl(
            afterTransitionId: transitionId,
            includingTransitionWithId: true,
            forTransitionsHandlers: [transitionsHandler],
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // будем искать среди всех анимирующих обработчиков, потому что отмена перехода
                // может случитсья на невидимом экране (из-за анимаций, например)
                return containingTransitionsHandler.allTransitionsHandlers
            }
        )
    }
    
    public func coordinateUndoingTransitionWith(
        transitionId transitionId: TransitionId,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    {
        // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        // среди всех анимирующих обработчиков (то есть среди всех tab'ов tabbar'a)
        guard let animatingTransitionsHandlers = transitionsHandler.allTransitionsHandlers
            else { return }
        
        coordinateUndoingTransitionsImpl(
            afterTransitionId: transitionId,
            includingTransitionWithId: true,
            forTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // продолжаем искать среди всех анимирующих обработчиков, потому что отмена перехода
                // может случитсья на невидимом экране (из-за анимаций, например)
                return containingTransitionsHandler.allTransitionsHandlers
            }
        )
    }
    
    public func coordinateUndoingAllChainedTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        // скрываем модальные окна и поповеры, показанные внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeeded(forTransitionsHandler: transitionsHandler)
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
            else { return }
        
        // отменить нужно только переход с открытием модального окна или поповера
        guard let chainedTransition = stackClient.chainedTransitionForTransitionsHandler(transitionsHandler)
            else { return }
        
        initiateUndoingTransitions(
            chainedTransition: chainedTransition,
            pushTransitions: nil,
            forTransitionsHandler: transitionsHandler,
            andCommitUndoingTransitionsAfter: chainedTransition.transitionId,
            includingTransitionWithId: true,
            withStackClient: stackClient
        )
    }
    
    public func coordinateUndoingAllTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        // скрываем модальные окна и поповеры, показанные внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeeded(forTransitionsHandler: transitionsHandler)
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
            else { return }
        
        // готовим список переходов, которые нужно отменить
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(transitionsHandler)
        
        // переход с открытием модального окна или поповера
        let chainedTransition = transitionsToUndo.chainedTransition
        
        // переходы по навигационному стеку
        let pushTransitions = transitionsToUndo.pushTransitions
        
        guard let firstTransitionId = pushTransitions?.first?.transitionId
            else { return }
        
        initiateUndoingTransitions(
            chainedTransition: chainedTransition,
            pushTransitions: pushTransitions,
            forTransitionsHandler: transitionsHandler,
            andCommitUndoingTransitionsAfter: firstTransitionId,
            includingTransitionWithId: false,
            withStackClient: stackClient
        )
    }
    
    public func coordinateResettingWithTransition(
        context context: ResettingTransitionContext,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    {
        var context = context
        
        // скрываем модальные окна и поповеры, показанные внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeeded(forTransitionsHandler: transitionsHandler)
        
        // ищем существующую историю переходов или создаем новую
        let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
            ?? stackClientProvider.createStackClient(forTransitionsHandler: transitionsHandler)
        
        // ищем идентификатор самого первого перехода
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(transitionsHandler)
        let chainedTransition = transitionsToUndo.chainedTransition
        let pushTransitions = transitionsToUndo.pushTransitions
        
        // скрываем модальные окна и поповеры текущего обработчика переходов
        // удаляем записи о первом и последующих переходах
        if let firstTransitionId = pushTransitions?.first?.transitionId {
            initiateUndoingTransitions(
                chainedTransition: chainedTransition,
                pushTransitions: nil, // только модальные окна и поповеры
                forTransitionsHandler: transitionsHandler,
                andCommitUndoingTransitionsAfter: firstTransitionId,
                includingTransitionWithId: false,
                withStackClient: stackClient
            )
        }
        
        if let lastTransition = stackClient.lastTransitionForTransitionsHandler(transitionsHandler) {
            // дополняем параметры анимации информацией о текущем верхнем контроллере
            context.resettingAnimationLaunchingContextBox.appendSourceViewController(
                lastTransition.targetViewController
            )
        }
        
        
        // уведомляем делегата до вызова `reset` анимаций
        transitionsCoordinatorDelegate?.transitionsCoordinator(
            coordinator: self,
            willLaunchResettingAnimation: context.resettingAnimationLaunchingContextBox.resettingTransitionsAnimatorBox,
            ofTransitionWith: context.transitionId
        )
        
        // вызываем анимации
        transitionsHandler.launchResettingAnimation(
            launchingContextBox: context.resettingAnimationLaunchingContextBox
        )
        
        // создаем новую запись о переходе
        commitResettingWithTransition(
            context: context,
            forTransitionsHandler: transitionsHandler,
            withStackClient: stackClient
        )
    }
}

// MARK: - preparing for undo
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func coordinateUndoingTransitionsImpl(
        afterTransitionId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandlers animatingTransitionsHandlers: [AnimatingTransitionsHandler],
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
    {
        // выбираем из анимирующих обработчиков тот, что ранее выполнил отменяемый переход
        let animatingTransitionsHandler = self.animatingTransitionsHandler(
            forTransitionsHandlers: animatingTransitionsHandlers,
            toUndoTransitionsAfterId: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        initiateUndoingTransitions(
            afterTransitionId: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
    
    func coordinateUndoingChainedTransitionsIfNeeded(forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        // по-хорошему нужно убрать все модальные окна и поповеры дочерних обработчиков переходов.
        // но обнаружились следующие особенности UIKit'а
        //
        // 1. iOS 8, 9:     если скрывать последовательность из поповеров,
        //                      то UIKit падает при анимировании больших (> 3) последовательностей
        //                  если не скрывать последовательности из поповеров, а скрывать только нижний,
        //                      то UIKit отрабатывает правильно
        // 2. iOS 7:        если скрывать последовательность из поповеров,
        //                      то UIKit отрабатывает правильно
        //                  если не скрывать последовательности из поповеров, а скрывать только нижний,
        //                      то UIKit падает, потому что ```popover dealloc reached while popover is visible```
        // 3. iOS 7, 8, 9:  если скрывать последовательность из модальных окон,
        //                      то UIKit не падает, но просто не выполняет сокрытие примерно на середине последовательности
        //
        // в итоге договорились  не убирать дочерние модальные окна и поповеры,
        // а на iOS 7 не использовать поповеры вообще или использовать аккуратно:
        //
        // а) на iOS 7 не показывать поповер в поповере
        // б) на iOS 7 не показывать поповеры внутри модальных окон
        // в) игнорировать пункты а) и б), но не вызывать сокрытие целой цепочки модальных окон и поповеров
    
        // в итоге только очищаем историю, но не выполняем анимаций
        coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler: transitionsHandler)
    }
    
    func coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler transitionsHandler: TransitionsHandler)
    {
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
            else { return }
        
        guard let chainedTransition = stackClient.chainedTransitionForTransitionsHandler(transitionsHandler)
            else { return }
        
        guard let chainedAnimatingTransitionsHandler = chainedTransition.targetTransitionsHandlerBox.unboxAnimatingTransitionsHandler()
            else { return }
        
        // начинаем с самого далекого дочернего обработчика
        coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler: chainedAnimatingTransitionsHandler)
        
        guard let chainedStackClient = stackClientProvider.stackClient(forTransitionsHandler: chainedAnimatingTransitionsHandler)
            else { return }
        
        // с дочерним закончили, удаляем историю текущего обработчика
        commitUndoingTransitionsAfter(
            transitionId: chainedTransition.transitionId,
            includingTransitionWithId: true,
            forTransitionsHandler: chainedAnimatingTransitionsHandler,
            withStackClient: chainedStackClient
        )
    }
}

// MARK: - initiating transitions (methods work only with AnimatingTransitionsHandler)
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func initiatePerformingTransition(
        context context: PresentationTransitionContext,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler?)
    {
        guard let animatingTransitionsHandler = animatingTransitionsHandler
            else { assert(false, "к этому моменту должен быть найден анимирующий обработчик"); return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { assert(false, "сначала нужно было делать resetWithTransition, а не performTransition"); return }
        
        guard let lastTransition = stackClient.lastTransitionForTransitionsHandler(animatingTransitionsHandler)
            else { assert(false, "сначала нужно было делать resetWithTransition, а не performTransition"); return }
        
        var context = context
        
        // уведомляем делегата до вызова `Presentation` анимаций
        transitionsCoordinatorDelegate?.transitionsCoordinator(
            coordinator: self,
            willLaunchPerfromingAnimation: context.presentationAnimationLaunchingContextBox.transitionsAnimatorBox,
            ofTransitionWithId: context.transitionId
        )
        
        // дополняем параметры анимации информацией о текущем верхнем контроллере
        context.presentationAnimationLaunchingContextBox.appendSourceViewController(
            lastTransition.targetViewController
        )
        
        // вызываем анимации
        animatingTransitionsHandler.launchPresentationAnimation(
            launchingContextBox: context.presentationAnimationLaunchingContextBox
        )
        
        // создаем новую запись о переходе
        commitPerformingTransition(
            context: context,
            byTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
    
    func initiateUndoingTransitions(
        afterTransitionId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler?)
    {
        guard let animatingTransitionsHandler = animatingTransitionsHandler else {
            debugPrint("обработчик, выполнивший переход с transitionId: \(transitionId), не найден. возможен лишний вызов метода отмены перехода")
            return
        }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { return }
        
        // готовим список переходов, которые нужно отменить
        let transitionsToUndo = stackClient.transitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: animatingTransitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
        
        // переход с открытием модального окна или поповера
        let chainedTransition = transitionsToUndo.chainedTransition
        
        // переходы по навигационному стеку
        let pushTransitions = transitionsToUndo.pushTransitions
        
        initiateUndoingTransitions(
            chainedTransition: chainedTransition,
            pushTransitions: pushTransitions,
            forTransitionsHandler: animatingTransitionsHandler,
            andCommitUndoingTransitionsAfter: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            withStackClient: stackClient
        )
    }
    
    func initiateUndoingTransitions(
        chainedTransition chainedTransition: RestoredTransitionContext?,
        pushTransitions: [RestoredTransitionContext]?,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // скрываем модальные окна и поповеры, показанные внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsIfNeeded(forTransitionsHandler: animatingTransitionsHandler)
        
        // вызываем анимации сокрытия модальных окон и поповеров
        if let chainedTransition = chainedTransition {
            initiateUndoingTransition(
                context: chainedTransition,
                whileUndoingTransitionWithId: transitionId,
                includingTransitionWithId: includingTransitionWithId,
                forTransitionsHandler: animatingTransitionsHandler,
                withStackClient: stackClient
            )
        }
        
        // вызываем анимации возвращения по навигационному стеку, минуя промежуточные переходы
        if let firstPushTransition = pushTransitions?.first {
            initiateUndoingTransition(
                context: firstPushTransition,
                whileUndoingTransitionWithId: transitionId,
                includingTransitionWithId: includingTransitionWithId,
                forTransitionsHandler: animatingTransitionsHandler,
                withStackClient: stackClient
            )
        }
        
        // удаляем записи об отмененных переходах
        commitUndoingTransitionsAfter(
            transitionId: transitionId,
            includingTransitionWithId: includingTransitionWithId,
            forTransitionsHandler: animatingTransitionsHandler,
            withStackClient: stackClient
        )
    }
    
    func initiateUndoingTransition(
        context context: RestoredTransitionContext,
        whileUndoingTransitionWithId targetTransitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // получаем информацию о переходе, предшествующем отменяемому переходу
        guard let precedingTransition = stackClient.transitionBefore(
            transitionId: context.transitionId,
            forTransitionsHandler: animatingTransitionsHandler
        ) else {
            assert(false, "нужно вызвать `resetWithTransition:` вместо того, чтобы отменять самый первый переход")
            return
        }
        
        // готовим параметры запуска анимации обратного перехода
        guard let dismissalAnimationLaunchingContextBox = DismissalAnimationLaunchingContextBox(
            presentationAnimationLaunchingContextBox: context.presentationAnimationLaunchingContextBox,
            targetViewController: precedingTransition.targetViewController
        ) else {
            debugPrint("FAILED TO CREATE `DismissalAnimationLaunchingContextBox` from `PresentationAnimationLaunchingContextBox`");
            return
        }
        
        // уведомляем делегата до вызова анимации обратного перехода. делегат может настроить анимированность обратного перехода
        if includingTransitionWithId {
            transitionsCoordinatorDelegate?.transitionsCoordinator(
                coordinator: self,
                willLaunchUndoingAnimation: dismissalAnimationLaunchingContextBox.transitionsAnimatorBox,
                ofTransitionWithId: targetTransitionId
            )
        }
        else {
            transitionsCoordinatorDelegate?.transitionsCoordinator(
                coordinator: self,
                willLaunchUndoingAnimation: dismissalAnimationLaunchingContextBox.transitionsAnimatorBox,
                ofTransitionsAfterId: targetTransitionId
            )
        }
        
        // запускаем анимацию обратного перехода
        animatingTransitionsHandler.launchDismissalAnimation(
            launchingContextBox: dismissalAnimationLaunchingContextBox
        )
    }
}

// MARK: - fetching data from the history (methods work only with AnimatingTransitionsHandler)
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    /// Выбор из обработчиков переходов одного с самым глубоким дочерним обработчиком.
    /// Возвращается найденный самый глубокий обработчик, чтобы прокинуть ему обработку перехода
    func deepestChainedAnimatingTransitionsHandler(
        forTransitionsHandlers transitionsHandlers: [AnimatingTransitionsHandler]?,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]? )
        -> AnimatingTransitionsHandler?
    {
        guard let transitionsHandlers = transitionsHandlers
            else { return nil }
        
        // нужно найти максимально вложенного дочернего обработчика переходов
        var chainedTransitionsHandlers = [AnimatingTransitionsHandler]()
        
        for transitionsHandler in transitionsHandlers {
            guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
                else { continue }
            
            guard let chainedTransitionsHandlerBox = stackClient.chainedTransitionsHandlerBoxForTransitionsHandler(transitionsHandler)
                else { continue }
            
            if let animatingTransitionsHandler = chainedTransitionsHandlerBox.unboxAnimatingTransitionsHandler() {
                chainedTransitionsHandlers.append(animatingTransitionsHandler)
            }
            else if let chainedContainingTransitionsHandler = chainedTransitionsHandlerBox.unboxContainingTransitionsHandler(),
                let childAnimatingTransitionsHandlers = unboxContainingTransitionsHandler(chainedContainingTransitionsHandler)
            {
                chainedTransitionsHandlers.appendContentsOf(childAnimatingTransitionsHandlers)
            }
        }
        
        // если нашли несколько дочерних обработчиков на одинаковой глубине вложенности, то берем любой.
        // у Split'а будет master, если ни master, ни detail не показывали модальных окон или поповеров
        if chainedTransitionsHandlers.isEmpty {
            return transitionsHandlers.first
        }
        
        // иначе продолжаем искать на следующей глубине вложенности
        return deepestChainedAnimatingTransitionsHandler(
            forTransitionsHandlers: chainedTransitionsHandlers,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler)
    }
    
    /// Поиск обработчика переходов, выполнявшего переход с переданным id.
    /// Если такой не найден, поиск продолжается по дочерним обработчикам
    func animatingTransitionsHandler(
        forTransitionsHandlers transitionsHandlers: [AnimatingTransitionsHandler]?,
        toUndoTransitionsAfterId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]? )
        -> AnimatingTransitionsHandler?
    {
        guard let transitionsHandlers = transitionsHandlers
            else { return nil }
        
        for transitionsHandler in transitionsHandlers {
            guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
                else { continue }
            
            // если какой-то обработчик выполнял переход с переданным id, возвращаем его
            if (stackClient.transitionWith(transitionId: transitionId, forTransitionsHandler: transitionsHandler) != nil) {
                return transitionsHandler
            }
            
            // иначе смотрим дочерние обработчики
            var chainedTransitionsHandlerBox = stackClient.chainedTransitionsHandlerBoxForTransitionsHandler(transitionsHandler)

            while chainedTransitionsHandlerBox != nil {
                // если дочерний - анимирующий
                if let chainedAnimatingTransitionsHandler = chainedTransitionsHandlerBox!.unboxAnimatingTransitionsHandler() {
                    guard let chainedStackClient = stackClientProvider.stackClient(forTransitionsHandler: chainedAnimatingTransitionsHandler)
                        else { assert(false); break }
                    
                    // если какой-то дочерний анимирующий обработчик выполнял переход с переданным id, возвращаем его
                    if (chainedStackClient.transitionWith(transitionId: transitionId, forTransitionsHandler: chainedAnimatingTransitionsHandler) != nil) {
                        return chainedAnimatingTransitionsHandler
                    }
                    
                    // иначе продолжаем искать среди его дочерних обработчиков
                    chainedTransitionsHandlerBox = chainedStackClient.chainedTransitionsHandlerBoxForTransitionsHandler(
                        chainedAnimatingTransitionsHandler)
                }
                // если дочерний - содержащий
                else if let chainedContainingTransitionsHandler = chainedTransitionsHandlerBox!.unboxContainingTransitionsHandler(),
                    let childAnimatingTransitionsHandlers = unboxContainingTransitionsHandler(chainedContainingTransitionsHandler)
                {
                    // если какой-то из вложенных обработчиков содержащего обработчика выполнял переход с переданным Id, возвращаем его
                    let subresult = animatingTransitionsHandler(
                        forTransitionsHandlers: childAnimatingTransitionsHandlers,
                        toUndoTransitionsAfterId: transitionId,
                        includingTransitionWithId: includingTransitionWithId,
                        unboxContainingTransitionsHandler: unboxContainingTransitionsHandler)
                    
                    if subresult != nil {
                        return subresult
                    }
                    
                    // иначе обрываем цикл
                    chainedTransitionsHandlerBox = nil
                }
                else { assert(false, "добавились новые виды обработчиков. нужно дописать код"); break }
            }
        }
        return nil
    }
}

// MARK: - for TopViewControllerFindable
extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func findTopViewControllerImpl(animatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler?)
        -> UIViewController?
    {
        guard let transitionsHandler = transitionsHandler
            else { return nil }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
            else { return nil }
        
        guard let lastTransition = stackClient.lastTransitionForTransitionsHandler(transitionsHandler)
            else { return nil }
        
        return lastTransition.targetViewController
    }
    
    func findTopViewControllerImpl(containingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
        -> UIViewController?
    {
        // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
        // среди видимых анимирующих обработчиков (то есть в выбранном tab'e tabbar'a)
        let animatingTransitionsHandlers = transitionsHandler.visibleTransitionsHandlers
        
        // выбираем из найденных анимирующих обработчиков один с самым глубоким дочерним анимирующим обработчиком
        // и получаем этого дочернего обработчика, чтобы прокинуть ему обработку перехода
        let animatingTransitionsHandler = deepestChainedAnimatingTransitionsHandler(
            forTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // продолжаем искать среди видимых анимирующих обработчиков (чтобы пользователь видел анимацию)
                return containingTransitionsHandler.visibleTransitionsHandlers
            }
        )
        
        return findTopViewControllerImpl(animatingTransitionsHandler: animatingTransitionsHandler)
    }
}

// MARK: - committing to the history (methods work only with AnimatingTransitionsHandler)
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func commitPerformingTransition(
        context context: PresentationTransitionContext,
        byTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        var context = context
        
        // если при инициировании перехода не указывали targetTransitionsHander'а, то указываем анимирующий
        if (context.needsAnimatingTargetTransitionHandler) {
            context.setAnimatingTargetTransitionsHandler(animatingTransitionsHandler)
        }

        // ищем последний переход, выполненный анимирующим обработчиком
        guard stackClient.lastTransitionForTransitionsHandler(animatingTransitionsHandler) != nil else {
            assert(false, "нужно было вызывать resetWithTransition(context:). а не performTransition(context:)")
            return
        }
        
        let completedTransitionContext = CompletedTransitionContext(
            presentationTransitionContext: context,
            sourceTransitionsHandler: animatingTransitionsHandler // кем выполнен переход
        )
        
        guard completedTransitionContext != nil
            else { assert(false); return }
        
        // создаем новую запись о переходе
        stackClient.appendTransition(
            context: completedTransitionContext!,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
    
    func commitUndoingTransitionsAfter(
        transitionId transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        stackClient.deleteTransitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: transitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
    }
    
    func commitResettingWithTransition(
        context context: ResettingTransitionContext,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        let completedTransitionContext = CompletedTransitionContext(
            resettingTransitionContext: context,
            sourceTransitionsHandler: animatingTransitionsHandler // кем выполнен переход
        )
        
        guard completedTransitionContext != nil
            else { assert(false); return }
        
        // создаем новую запись о переходе
        stackClient.appendTransition(
            context: completedTransitionContext!,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
}
