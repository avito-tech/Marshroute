/// Параметры перехода, на которые нужно держать сильную ссылку при хранении в истории переходов
/// (например, UIPopoverController или дочерний обработчик переходов)
protocol TransitionStorableParameters {}

extension TransitionStorableParameters {
    func releaseStorableParameters() {}
}