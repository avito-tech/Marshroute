import Foundation

protocol TransitionsGeneratorStorer: class {
    var transitionIdGenerator: TransitionIdGenerator { get set }
}

extension TransitionsGeneratorStorer {
    var transitionIdGenerator: TransitionIdGenerator {
        get { return TransitionIdGeneratorImpl.instance }
        set { }
    }
}