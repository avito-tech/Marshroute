public protocol TransitionIdGeneratorHolder: AnyObject {
    var transitionIdGenerator: TransitionIdGenerator { get }
}
