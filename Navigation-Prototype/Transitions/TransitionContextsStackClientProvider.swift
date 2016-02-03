import Foundation

protocol TransitionContextsStackClientProvider: class {
    func stackClient(forTransitionsHandler transitionsHandler: TransitionsHandler) -> TransitionContextsStackClient?
    func createStackClient(forTransitionsHandler transitionsHandler: TransitionsHandler) -> TransitionContextsStackClient
}