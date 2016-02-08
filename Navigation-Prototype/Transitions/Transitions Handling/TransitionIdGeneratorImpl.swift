import Foundation

final class TransitionIdGeneratorImpl {
    static let instance = TransitionIdGeneratorImpl()
}

extension TransitionIdGeneratorImpl: TransitionIdGenerator {
    func generateNewTransitionId()
        -> TransitionId
    {
        let result = NSUUID().UUIDString
        return result
    }
}
