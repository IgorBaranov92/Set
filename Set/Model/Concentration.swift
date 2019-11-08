import Foundation

class Concentration {
    
    static private(set) var scores = 0

    private(set) var cards = [ConcentrationCard]()
    private(set) var flipCount = 0
    private(set) var cardsAreMatched = false
    private var firstDate = Date()
    private(set) var lastChosenIndex: Int?
    
    var gameCompleted: Bool { cards.filter { $0.isMatched }.count == cards.count }
    
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if lastChosenIndex == nil {
                firstDate = Date()
                cardsAreMatched = false
                lastChosenIndex = index
                cards[index].isFaceUp = true
            } else if lastChosenIndex != nil, lastChosenIndex != index {
                cards[index].isFaceUp = true
                if cards[index] == cards[lastChosenIndex!] {
                    cards[index].isMatched = true
                    cards[lastChosenIndex!].isMatched = true
                    cardsAreMatched = true
                    if (cards.filter{ !$0.isMatched}.count) >= 6 {
                        Concentration.scores += calculateScoresBasedOnDifferenceBetween(firstDate,Date()).rawValue
                    } else {
                        Concentration.scores += 2
                    }
                } else {
                    if cards[index].alreadySeen {
                        cards[index].numberOfMismatchedInvolded += 1
                        Concentration.scores -= cards[index].numberOfMismatchedInvolded
                    }
                    if cards[lastChosenIndex!].alreadySeen {
                        cards[lastChosenIndex!].numberOfMismatchedInvolded += 1
                        Concentration.scores -= cards[lastChosenIndex!].numberOfMismatchedInvolded
                    }
                    cards[index].alreadySeen = true
                    cards[lastChosenIndex!].alreadySeen = true
                }
                cards[index].isFaceUp = false
                cards[lastChosenIndex!].isFaceUp = false
                lastChosenIndex = nil
            }
        }
    }
    
    private enum Speed: Int {
        case superfast = 4
        case fast = 3
        case regular = 2
    }
    
    private func calculateScoresBasedOnDifferenceBetween(_ firstDate:Date,_ secondDate:Date) -> Speed {
        let difference = secondDate.timeIntervalSince(firstDate)
        switch difference {
        case 0...1: return .superfast
        case 1.01...2: return .fast
        default:return .regular
        }
    }
    
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card]
        }
        cards.shuffle()
        let newCards = cards.shuffled()
        cards += newCards
        flipCount = 0
        lastChosenIndex = nil
        cardsAreMatched = false
    }
    
    
    
}
