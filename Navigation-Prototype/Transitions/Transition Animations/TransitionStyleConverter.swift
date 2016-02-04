/// Парсинг общего перечисления переходов в перечисление переходов для конкретного аниматора.
/// Например, аниматор поповеров не будет уметь делать push, pop.
protocol TransitionStyleConverter: class {
    typealias ConvertedAnimationStyle
    
    func convertTransitionStyle(style: TransitionStyle)
        -> ConvertedAnimationStyle?
}