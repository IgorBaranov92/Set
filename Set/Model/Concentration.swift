import Foundation

class Concentration {
    
    static private(set) var scores = 0

    private(set) var cards = [ConcentrationCard]()
    private(set) var lastChosenIndex: Int?
    private(set) var flipCount = 0
    private(set) var cardsAreMatched = false
    
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if lastChosenIndex == nil {
                cardsAreMatched = false
                lastChosenIndex = index
                cards[index].isFaceUp = true
            } else if lastChosenIndex != nil, lastChosenIndex != index {
                cards[index].isFaceUp = true
                if cards[index] == cards[lastChosenIndex!] {
                    Concentration.scores += 2
                    cards[index].isMatched = true
                    cards[lastChosenIndex!].isMatched = true
                    cardsAreMatched = true
                } else {
                    if cards[index].alreadySeen { Concentration.scores -= 1 }
                    if cards[lastChosenIndex!].alreadySeen { Concentration.scores -= 1 }
                    cards[index].alreadySeen = true
                    cards[lastChosenIndex!].alreadySeen = true
                }
                cards[index].isFaceUp = false
                cards[lastChosenIndex!].isFaceUp = false
                lastChosenIndex = nil
            }
        }
    }
    
    var gameCompleted: Bool {
        return cards.filter { $0.isMatched }.count == cards.count
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card,card]
        }
        cards = cards.shuffled()
        flipCount = 0
        lastChosenIndex = nil
        cardsAreMatched = false
    }
    
}
