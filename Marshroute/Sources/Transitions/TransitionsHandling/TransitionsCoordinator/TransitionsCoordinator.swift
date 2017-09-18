import UIKit

/// Протокол описывает передачу обработки и отмены переходов в центр управления переходами
public protocol TransitionsCoordinator: class {
    func coordinatePerformingTransition(
        context: PresentationTransitionContext,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinatePerformingTransition(
        context: PresentationTransitionContext,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    
    func coordinateUndoingTransitionsAfter(
        transitionId: TransitionId,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateUndoingTransitionsAfter(
        transitionId: TransitionId,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    
    func coordinateUndoingTransitionWith(
        transitionId: TransitionId,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateUndoingTransitionWith(
        transitionId: TransitionId,
        forContainingTransitionsHandler transitionsHandler: ContainingTransitionsHandler)
    
    func coordinateUndoingAllChainedTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateUndoingAllTransitions(
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
    
    func coordinateResettingWithTransition(
        context: ResettingTransitionContext,
        forAnimatingTransitionsHandler transitionsHandler: AnimatingTransitionsHandler)
}

// MARK: - TransitionsCoordinator Default Impl
extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder,
    Self: TransitionsMarkersHolder,
    Self: PeekAndPopTransitionsCoordinatorHolder
{
    public func coordinatePerformingTransition(
        context: PresentationTransitionContext,
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
        context: PresentationTransitionContext,
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
        transitionId: TransitionId,
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
        transitionId: TransitionId,
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
        transitionId: TransitionId,
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
        transitionId: TransitionId,
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
        coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler: transitionsHandler)
        
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
        coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler: transitionsHandler)
        
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
        context: ResettingTransitionContext,
        forAnimatingTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler)
    {
        var context = context
        
        // скрываем модальные окна и поповеры, показанные внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler: animatingTransitionsHandler)
        
        // ищем существующую историю переходов или создаем новую
        let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            ?? stackClientProvider.createStackClient(forTransitionsHandler: animatingTransitionsHandler)
        
        // ищем идентификатор самого первого перехода
        let transitionsToUndo = stackClient.allTransitionsForTransitionsHandler(animatingTransitionsHandler)
        let chainedTransition = transitionsToUndo.chainedTransition
        let pushTransitions = transitionsToUndo.pushTransitions
        
        // скрываем модальные окна и поповеры текущего обработчика переходов
        // удаляем записи о первом и последующих переходах
        if let firstTransitionId = pushTransitions?.first?.transitionId {
            initiateUndoingTransitions(
                chainedTransition: chainedTransition,
                pushTransitions: nil, // только модальные окна и поповеры
                forTransitionsHandler: animatingTransitionsHandler,
                andCommitUndoingTransitionsAfter: firstTransitionId,
                includingTransitionWithId: false,
                withStackClient: stackClient
            )
        }
        
        if case .resettingNavigationRoot = context.resettingAnimationLaunchingContextBox {
            if let lastTransition = stackClient.lastTransitionForTransitionsHandler(animatingTransitionsHandler) {
                // дополняем параметры анимации информацией о текущем верхнем контроллере
                context.resettingAnimationLaunchingContextBox.appendSourceViewController(
                    lastTransition.targetViewController
                )
            } else {
                debugPrint(
                    "Cannot reset `rootViewController` of a `UINavigationController`." +
                    "No `rootViewController` found. You should first set `rootViewController`." +
                    "see `ResettingAnimationLaunchingContextBox.resettingNavigationRoot`"
                )
                return
            }
        }
        
        // спрашиваем делегата о разрешении выполнения анимаций `Resetting` перехода,
        // если переход помечен пользовательским идентификатором
        let transitionUserId = markers[context.transitionId]
        
        let transitionAllowed: Bool
        
        if let transitionUserId = transitionUserId,
            let transitionsCoordinatorDelegate = transitionsCoordinatorDelegate
        {
            transitionAllowed = transitionsCoordinatorDelegate.transitionsCoordinator(
                coordinator: self,
                canForceTransitionsHandler: animatingTransitionsHandler,
                toLaunchResettingAnimationOfTransition: context,
                markedWithUserId: transitionUserId
            )
        } else {
            transitionAllowed = true
        }
        
        if transitionAllowed {
            // уведомляем делегата до вызова анимации `Resetting` перехода.
            transitionsCoordinatorDelegate?.transitionsCoordinator(
                coordinator: self,
                willForceTransitionsHandler: animatingTransitionsHandler,
                toLaunchResettingAnimationOfTransition: context
            )
            
            // вызываем анимации, передавая параметры запуска анимации по ссылке,
            // потому что они могут быть дополнены недостающими параметрами, например, UINavigationController'ом
            animatingTransitionsHandler.launchResettingAnimation(
                launchingContextBox: &context.resettingAnimationLaunchingContextBox
            )
            
            // создаем новую запись о переходе
            commitResettingWithTransition(
                context: context,
                forTransitionsHandler: animatingTransitionsHandler,
                withStackClient: stackClient
            )
        } else {
            debugPrint("resetting transition was cancelled")
        }
        
    }
}

// MARK: - preparing for undo
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder,
    Self: TransitionsMarkersHolder,
    Self: PeekAndPopTransitionsCoordinatorHolder
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
    Self: TransitionsCoordinatorDelegateHolder,
    Self: TransitionsMarkersHolder,
    Self: PeekAndPopTransitionsCoordinatorHolder
{
    func initiatePerformingTransition(
        context: PresentationTransitionContext,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler?)
    {
        guard let animatingTransitionsHandler = animatingTransitionsHandler
            else { assert(false, "к этому моменту должен быть найден анимирующий обработчик"); return }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
            else { assert(false, "сначала нужно было делать resetWithTransition, а не performTransition"); return }
        
        guard let lastTransition = stackClient.lastTransitionForTransitionsHandler(animatingTransitionsHandler)
            else { assert(false, "сначала нужно было делать resetWithTransition, а не performTransition"); return }
        
        // спрашиваем делегата о разрешении выполнения анимаций `Resetting` перехода,
        // если переход помечен пользовательским идентификатором
        let transitionUserId = markers[context.transitionId]
        let transitionAllowed: Bool
        
        if let transitionUserId = transitionUserId,
            let transitionsCoordinatorDelegate = transitionsCoordinatorDelegate
        {
            transitionAllowed = transitionsCoordinatorDelegate.transitionsCoordinator(
                coordinator: self,
                canForceTransitionsHandler: animatingTransitionsHandler,
                toLaunchPresentationAnimationOfTransition: context,
                markedWithUserId: transitionUserId
            )
        } else {
            transitionAllowed = true
        }
        
        if transitionAllowed {
            let transitionId = context.transitionId
            let targetViewController = context.targetViewController
            let targetTransitionsHandlerBox = context.targetTransitionsHandlerBox
            let storableParameters = context.storableParameters
            let presentationAnimationLaunchingContextBox = context.presentationAnimationLaunchingContextBox
            
            peekAndPopTransitionsCoordinator.coordinatePeekIfNeededFor(
                viewController: context.targetViewController,
                popAction: { [weak self, weak targetViewController] in
                    guard let strongSelf = self, 
                        let targetViewController = targetViewController
                        else { return }
                    
                    var context = PresentationTransitionContext(
                        transitionId: transitionId,
                        targetViewController: targetViewController,
                        targetTransitionsHandlerBox: targetTransitionsHandlerBox,
                        storableParameters: storableParameters,
                        presentationAnimationLaunchingContextBox: presentationAnimationLaunchingContextBox
                    )
                    
                    // уведомляем делегата до вызова анимации `Presentation` перехода.
                    strongSelf.transitionsCoordinatorDelegate?.transitionsCoordinator(
                        coordinator: strongSelf,
                        willForceTransitionsHandler: animatingTransitionsHandler,
                        toLaunchPresentationAnimationOfTransition: context
                    )
                    
                    // дополняем параметры анимации информацией о текущем верхнем контроллере
                    context.presentationAnimationLaunchingContextBox.appendSourceViewController(
                        lastTransition.targetViewController
                    )
                    
                    // вызываем анимации, передавая параметры запуска анимации по ссылке,
                    // потому что они могут быть дополнены недостающими параметрами, например, UINavigationController'ом
                    animatingTransitionsHandler.launchPresentationAnimation(
                        launchingContextBox: &context.presentationAnimationLaunchingContextBox
                    )
                    
                    // создаем новую запись о переходе
                    strongSelf.commitPerformingTransition(
                        context: context,
                        byTransitionsHandler: animatingTransitionsHandler,
                        withStackClient: stackClient
                    )
                }
            )
        } else {
            debugPrint("presentation transition was cancelled")
        }
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
        chainedTransition: RestoredTransitionContext?,
        pushTransitions: [RestoredTransitionContext]?,
        forTransitionsHandler animatingTransitionsHandler: AnimatingTransitionsHandler,
        andCommitUndoingTransitionsAfter transitionId: TransitionId,
        includingTransitionWithId: Bool,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        // скрываем модальные окна и поповеры, показанные внутри модальных окон и поповеров текущего обработчика
        coordinateUndoingChainedTransitionsWithoutAnimations(forTransitionsHandler: animatingTransitionsHandler)
        
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
        context: RestoredTransitionContext,
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
        
        guard let presentationAnimationLaunchingContextBox
            = context.sourceAnimationLaunchingContextBox.unboxPresentationAnimationLaunchingContextBox() else {
            assert(false, "невозможно сделать обратный переход для `reset`-перехода. только для `presentation`-перехода")
            return
        }
        
        // готовим параметры запуска анимации обратного перехода
        guard let dismissalAnimationLaunchingContextBox = DismissalAnimationLaunchingContextBox(
            presentationAnimationLaunchingContextBox: presentationAnimationLaunchingContextBox,
            targetViewController: precedingTransition.targetViewController
        ) else {
            debugPrint("FAILED TO CREATE `DismissalAnimationLaunchingContextBox` from `PresentationAnimationLaunchingContextBox`")
            return
        }
        
        // уведомляем делегата до вызова анимации обратного перехода. делегат может настроить анимированность обратного перехода
        if includingTransitionWithId {
            transitionsCoordinatorDelegate?.transitionsCoordinator(
                coordinator: self,
                willForceTransitionsHandler: animatingTransitionsHandler,
                toLaunchDismissalAnimationByAnimator: dismissalAnimationLaunchingContextBox.transitionsAnimatorBox,
                ofTransitionWithId: targetTransitionId
            )
        } else {
            transitionsCoordinatorDelegate?.transitionsCoordinator(
                coordinator: self,
                willForceTransitionsHandler: animatingTransitionsHandler,
                toLaunchDismissalAnimationByAnimator: dismissalAnimationLaunchingContextBox.transitionsAnimatorBox,
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
    Self: TransitionsCoordinatorDelegateHolder,
    Self: TransitionsMarkersHolder
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
            
            let chainedAnimatingTransitionsHandlers = animatingTransitionsHandlersForTransitionsHandlerBox(
                chainedTransitionsHandlerBox,
                unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
            )
            
            chainedTransitionsHandlers.append(contentsOf: chainedAnimatingTransitionsHandlers)
        }
        
        // нашли несколько дочерних обработчиков на одинаковой глубине вложенности, 
        // не показывавших модальные окна и поповеры.
        // подойдет любой
        if chainedTransitionsHandlers.isEmpty {
            return selectTransitionsHandler(
                tantamountAnimatingTransitionsHandlers: transitionsHandlers
            )
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
                } else { assert(false, "добавились новые виды обработчиков. нужно дописать код"); break }
            }
        }
        return nil
    }
}

// MARK: - for TopViewControllerFinder
extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder,
    Self: TransitionsMarkersHolder
{
    func findTopViewControllerImpl(forTransitionsHandlerBox transitionsHandlerBox: TransitionsHandlerBox)
        -> UIViewController?
    {
        let unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?
            = { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
                // среди видимых анимирующих обработчиков (то есть в выбранном tab'e tabbar'a)
                return containingTransitionsHandler.visibleTransitionsHandlers
        }
        
        let animatingTransitionsHandlers = animatingTransitionsHandlersForTransitionsHandlerBox(
            transitionsHandlerBox,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        return findTopViewControllerImpl(
            forTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
    }
        
    private func findTopViewControllerImpl(
        forTransitionsHandlers transitionsHandlers: [AnimatingTransitionsHandler]?,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> UIViewController?
    {
        let deepestChainedTransitionsHandler = deepestChainedAnimatingTransitionsHandler(
            forTransitionsHandlers: transitionsHandlers,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        guard let transitionsHandler = deepestChainedTransitionsHandler
            else { return nil }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
            else { return nil }
        
        guard let lastTransition = stackClient.lastTransitionForTransitionsHandler(transitionsHandler)
            else { return nil }
        
        return lastTransition.targetViewController
    }
}

// MARK: - for TransitionsTracker
extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func countOfTransitionsAfterTrackedTransitionImpl(
        _ trackedTransition: TrackedTransition,
        untilLastTransitionOfTransitionsHandler targetTransitionsHandler: TransitionsHandler)
        -> Int?
    {
        let transitionsHandlerBox = trackedTransition.transitionsHandlerBox
        let transitionsHandler = transitionsHandlerBox.unbox()
        
        let unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?
            = { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
                // среди всех анимирующих обработчиков (то есть во всех tab'ах tabbar'a)
                return containingTransitionsHandler.allTransitionsHandlers
        }

        let animatingTransitionsHandlers = animatingTransitionsHandlersForTransitionsHandlerBox(
            transitionsHandlerBox,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        for _ in animatingTransitionsHandlers {
            if let result = countOfTransitionsAfterTransitionWithId(
                trackedTransition.transitionId,
                performedByTransitionsHandler: transitionsHandler,
                untilLastTransitionOfTransitionsHandler: targetTransitionsHandler,
                unboxContainingTransitionsHandler: unboxContainingTransitionsHandler)
            {
                return result
            }
        }
        
        return nil
    }
    
    private func countOfTransitionsAfterTransitionWithId(
        _ transitionId: TransitionId,
        performedByTransitionsHandler fromTransitionsHandler: TransitionsHandler,
        untilLastTransitionOfTransitionsHandler toTransitionsHandler: TransitionsHandler,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> Int?
    {
        let transitionsHandlersPath = transitionHandlersPath(
            fromTransitionsHandler: fromTransitionsHandler,
            toTransitionsHandler: toTransitionsHandler,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        guard let transitionsHandlers = transitionsHandlersPath
            else { return nil }
        
        var result = 0
        
        for transitionsHandler in transitionsHandlers {
            guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: transitionsHandler)
                else { return nil }
            
            let (chainedTransition, pushTransitions): (RestoredTransitionContext?, [RestoredTransitionContext]?)
            
            if transitionsHandler === fromTransitionsHandler {
                // у начально нужно считать только переходы после переданного идентификатора
                (chainedTransition, pushTransitions) = stackClient.transitionsAfter(
                    transitionId: transitionId,
                    forTransitionsHandler: transitionsHandler,
                    includingTransitionWithId: false
                )
            } else {
                // у дочерних нужно считать все перерходы
                (chainedTransition, pushTransitions) = stackClient.allTransitionsForTransitionsHandler(
                    transitionsHandler
                )
                
                // кроме первого (`Resetting`) перехода
                pushTransitions?.removeFirst()
            }
            
            result += pushTransitions?.count ?? 0
            result += (chainedTransition != nil) ? 1 : 0
        }
        
        return result
    }

    private func transitionHandlersPath(
        fromTransitionsHandler: TransitionsHandler,
        toTransitionsHandler: TransitionsHandler,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> [TransitionsHandler]?
    {
        if fromTransitionsHandler === toTransitionsHandler {
            return [fromTransitionsHandler]
        }
        
        guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: fromTransitionsHandler)
            else { return nil }
        
        guard let chainedTransition = stackClient.chainedTransitionForTransitionsHandler(fromTransitionsHandler)
            else { return nil }
        
        let chainedTransitionsHandlerBox = chainedTransition.targetTransitionsHandlerBox
        
        let animatingTransitionsHandlers = animatingTransitionsHandlersForTransitionsHandlerBox(
            chainedTransitionsHandlerBox,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        for animatingTransitionsHandler in animatingTransitionsHandlers {
            let subPath = transitionHandlersPath(
                fromTransitionsHandler: animatingTransitionsHandler,
                toTransitionsHandler: toTransitionsHandler,
                unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
            )
            
            if let subPath = subPath {
                var result = [fromTransitionsHandler]
                result.append(contentsOf: subPath)
                return result
            }
        }
        
        return nil
    }
    
    func restoredTransitionFromTrackedTransition(
        _ trackedTransition: TrackedTransition,
        searchingFromTransitionsHandlerBox transitionsHandlerBox: TransitionsHandlerBox)
        -> RestoredTransitionContext?
    {
        let unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?
            = { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
                // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
                // среди всех анимирующих обработчиков (то есть во всех tab'ах tabbar'a)
                return containingTransitionsHandler.allTransitionsHandlers
        }
        
        let animatingTransitionsHandlers = animatingTransitionsHandlersForTransitionsHandlerBox(
            transitionsHandlerBox,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        return restoredTransitionFromTrackedTransition(
            trackedTransition,
            amongTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
    }
    
    private func restoredTransitionFromTrackedTransition(
        _ trackedTransition: TrackedTransition,
        amongTransitionsHandlers animatingTransitionsHandlers: [AnimatingTransitionsHandler],
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> RestoredTransitionContext?
    {
        let transitionId = trackedTransition.transitionId
        let transitionsHandler = trackedTransition.transitionsHandlerBox.unbox()
        
        var chainedAnimatingTransitionsHandlers = [AnimatingTransitionsHandler]()
        
        for animatingTransitionsHandler in animatingTransitionsHandlers {
            guard let stackClient = stackClientProvider.stackClient(forTransitionsHandler: animatingTransitionsHandler)
                else { continue }
            
            let resultIfNotOptional = stackClient.transitionWith(
                transitionId: transitionId,
                forTransitionsHandler: transitionsHandler
            )
            
            if let result = resultIfNotOptional {
                return result
            }
            
            guard let chainedTransition = stackClient.chainedTransitionForTransitionsHandler(animatingTransitionsHandler)
                else { continue }
            
            let chainedAnimatingTransitionsHandlersPart = animatingTransitionsHandlersForTransitionsHandlerBox(
                chainedTransition.targetTransitionsHandlerBox,
                unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
            )
            
            chainedAnimatingTransitionsHandlers.append(contentsOf: chainedAnimatingTransitionsHandlersPart)
        }
        
        if !chainedAnimatingTransitionsHandlers.isEmpty {
            return restoredTransitionFromTrackedTransition(
                trackedTransition,
                amongTransitionsHandlers: chainedAnimatingTransitionsHandlers,
                unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
            )
        }
        
        return nil
    }
}

// MARK: - for TransitionsMarker
extension TransitionsCoordinator where
    Self: TransitionsMarkersHolder
{
    func markTransitionIdImpl(transitionId: TransitionId, withUserId userId: TransitionUserId) {
        markers[transitionId] = userId
    }
}

// MARK: - Utils
private extension TransitionsCoordinator {
    func animatingTransitionsHandlersForTransitionsHandlerBox(
        _ transitionsHandlerBox: TransitionsHandlerBox,
        unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?)
        -> [AnimatingTransitionsHandler]
    {
        var result = [AnimatingTransitionsHandler]()
        
        if let animatingTransitionsHandler = transitionsHandlerBox.unboxAnimatingTransitionsHandler() {
            result.append(animatingTransitionsHandler)
        } else if let containingTransitionsHandler = transitionsHandlerBox.unboxContainingTransitionsHandler(),
            let childAnimatingTransitionsHandlers = unboxContainingTransitionsHandler(containingTransitionsHandler)
        {
            result.append(contentsOf: childAnimatingTransitionsHandlers)
        }
        
        return result
    }
}

// MARK: - Picking one of tantamount transitions handlers
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func selectTransitionsHandler(
        tantamountAnimatingTransitionsHandlers transitionsHandlers: [AnimatingTransitionsHandler])
        -> AnimatingTransitionsHandler?
    {
        // если нашли несколько равноправных обработчиков, то берем последний.
        // например, среди анимирующих обработчиков SplitViewTransitionsHandler будет выбран detail
        return transitionsHandlers.last
    }
}

// MARK: - committing to the history (methods work only with AnimatingTransitionsHandler)
private extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder
{
    func commitPerformingTransition(
        context: PresentationTransitionContext,
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
        _ = stackClient.appendTransition(
            context: completedTransitionContext!,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
    
    func commitUndoingTransitionsAfter(
        transitionId: TransitionId,
        includingTransitionWithId: Bool,
        forTransitionsHandler transitionsHandler: TransitionsHandler,
        withStackClient stackClient: TransitionContextsStackClient)
    {
        _ = stackClient.deleteTransitionsAfter(
            transitionId: transitionId,
            forTransitionsHandler: transitionsHandler,
            includingTransitionWithId: includingTransitionWithId
        )
    }
    
    func commitResettingWithTransition(
        context: ResettingTransitionContext,
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
        _ = stackClient.appendTransition(
            context: completedTransitionContext!,
            forTransitionsHandler: animatingTransitionsHandler
        )
    }
}

// MARK: - for TransitionsHandlerProvider
extension TransitionsCoordinator where
    Self: TransitionContextsStackClientProviderHolder,
    Self: TransitionsCoordinatorDelegateHolder,
    Self: TransitionsMarkersHolder
{
    func animatingTransitionsHandlerImpl()
        -> AnimatingTransitionsHandler
    {
        return AnimatingTransitionsHandler(
            transitionsCoordinator: self
        )
    }
    
    func navigationTransitionsHandlerImpl(navigationController: UINavigationController)
        -> NavigationTransitionsHandlerImpl
    {
        return NavigationTransitionsHandlerImpl(
            navigationController: navigationController,
            transitionsCoordinator: self
        )
    }
    
    func topTransitionsHandlerBoxImpl(transitionsHandlerBox: TransitionsHandlerBox)
        -> TransitionsHandlerBox
    {
        let unboxContainingTransitionsHandler: (ContainingTransitionsHandler) -> [AnimatingTransitionsHandler]?
        = { (containingTransitionsHandler) -> [AnimatingTransitionsHandler]? in
            // будем искать вложенные анимирующие обработчики переходов (например, для split'а, найдем его master и detail)
            // среди видимых анимирующих обработчиков (то есть в выбранном tab'e tabbar'a)
            return containingTransitionsHandler.visibleTransitionsHandlers
        }
        
        let animatingTransitionsHandlers = animatingTransitionsHandlersForTransitionsHandlerBox(
            transitionsHandlerBox,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        let deepestChainedAnimatingTransitionsHandler = self.deepestChainedAnimatingTransitionsHandler(
            forTransitionsHandlers: animatingTransitionsHandlers,
            unboxContainingTransitionsHandler: unboxContainingTransitionsHandler
        )
        
        if let animatingTransitionsHandler = deepestChainedAnimatingTransitionsHandler {
            return .init(animatingTransitionsHandler: animatingTransitionsHandler)
        }
        
        return transitionsHandlerBox
    }
    
    func splitViewTransitionsHandlerImpl(splitViewController: UISplitViewController)
        -> SplitViewTransitionsHandlerImpl
    {
        return SplitViewTransitionsHandlerImpl(
            splitViewController: splitViewController,
            transitionsCoordinator: self
        )
    }
    
    func tabBarTransitionsHandlerImpl(tabBarController: UITabBarController)
        -> TabBarTransitionsHandlerImpl
    {
        return TabBarTransitionsHandlerImpl(
            tabBarController: tabBarController,
            transitionsCoordinator: self
        )
    }
}
