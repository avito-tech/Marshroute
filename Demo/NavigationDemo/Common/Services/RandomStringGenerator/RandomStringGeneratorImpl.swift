import Foundation

final class RandomStringGeneratorImpl: RandomStringGenerator {
    // MARK: - RandomStringGenerator
    func randomSentence() -> String {
        let wordsCount = arc4random() % 7 + 2
        
        var words = [String]()
        
        for _ in 0 ..< wordsCount {
            words.append(randomWord())
        }
        
        words[0] = words[0].capitalizedString
        
        return words.joinWithSeparator(" ")
    }
    
    func randomTextStartingWith(prefix: String) -> String {
        let paragraphsCount = arc4random() % 5 + 5
        
        var paragraphs = [String]()
        
        for i in 0 ..< paragraphsCount {
            let parahraph = randomParagraph(
                startingWithSpaces: i != 0
            )
            paragraphs.append(parahraph)
        }
        
        return prefix + " - " + paragraphs.joinWithSeparator("\n\n")
    }
    
    // MARK: - Private
    private func randomParagraph(startingWithSpaces startingWithSpaces: Bool) -> String {
        let sentencesCount = arc4random() % 10 + 8
        
        var sentences = [String]()
        
        for _ in 0 ..< sentencesCount {
            sentences.append(randomSentence())
        }
        
        if startingWithSpaces {
            sentences[0] = "    " + sentences[0]
        }
        
        return sentences.joinWithSeparator(". ")
    }
    
    private func randomWord() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let wordLength = arc4random() % 10 + 2
        
        var randomString = ""
        
        for _ in 0 ..< wordLength {
            let length = UInt32(letters.characters.count)
            let advanceDistance = Int(arc4random_uniform(length))
            let character = letters[letters.startIndex.advancedBy(advanceDistance)]
            randomString.append(character)
        }
        
        return randomString
    }
}