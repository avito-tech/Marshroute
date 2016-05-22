import Foundation

protocol RandomStringGenerator: class {
    func randomSentence() -> String
    func randomTextStartingWith(prefix: String) -> String
}
