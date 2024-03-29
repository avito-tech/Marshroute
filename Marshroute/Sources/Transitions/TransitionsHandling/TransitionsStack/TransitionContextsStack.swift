/// Стэк, который хранит CompletedTransitionContext, а возвращает RestoredTransitionContext.
/// Стэк хранит историю переходов по одному навигационному контроллеру.
/// Стэк может завершаться переходом на дочернего обработчика переходов (на модальное окно или поповер)
public protocol TransitionContextsStack: AnyObject {
    /// добавляет запись
    func append(_ context: CompletedTransitionContext)

    /// возвращает, но не удаляет первую запись
    var first: RestoredTransitionContext? { get }
    
    /// возвращает, но не удаляет последнюю запись
    var last: RestoredTransitionContext? { get }
    
    /// удаляет последнюю запись
    func popLast()
        -> RestoredTransitionContext?
    
    /// возвращает, но не удаляет запись с переданным Id
    subscript(transitionId: TransitionId) -> RestoredTransitionContext? { get }
    
    /// удаляет записи по одной с конца до записи с переданным Id невключительно, если запись с переданным Id вообще есть
    func popTo(transitionId: TransitionId)
        -> [RestoredTransitionContext]?

    /// возвращает, но не удаляет запись, предшествующую записи с переданным Id
    func preceding(transitionId: TransitionId)
        -> RestoredTransitionContext?
    
    /// очищает записи, оставшиеся от экранов, которые по каким-то причинам не деаллоцировались после их исчезновения
    /// из навигационного стека, если это исчезновение произошло в обход методов Marshroute'a:
    /// - swipe'нули назад
    /// - нажали < Back
    /// - нажали на таб
    /// - свайпнули вниз по модальному экрану 
    func clearContextsDescribingScreensThatWereAlreadyDismissedWithoutInvokingMarshroute()
}
