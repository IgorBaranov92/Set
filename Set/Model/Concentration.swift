import Foundation

class Concentration {
    
    weak var delegate: ConcentrationGameDelegate?
    static private(set) var scores = 0
    private(set) var cards = [ConcentrationCard]()
    private(set) var flipCount = 0
    
    var gameCompleted: Bool { cards.filter { $0.isMatched }.count == cards.count }
    
    var selectedCards: [ConcentrationCard] { cards.filter { $0.isFaceUp } }
    
    private var cardsAreMatched: Bool {
        Set(selectedCards.map {Int($0.identifier)}).count == 1
    }
    
    private var penalty: Int {
        selectedCards.map{$0.numberOfMismatchedInvolded}.reduce(0,{$0+$1})
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            cards[index].isFaceUp = true
            if selectedCards.count == 3 {
                if cardsAreMatched {
                    Concentration.scores += 2
                    setCardsMatched()
                    delegate?.matchWasFound()
                } else {
                    setPenaltyForSelectedCards()
                    Concentration.scores -= penalty
                    delegate?.matchWasNotFound()
                }
                flipBackCards()
            }
        }

    }

    private func flipBackCards() {
        for index in cards.indices {
            cards[index].isFaceUp = false
        }
    }
    
    private func setCardsMatched() {
        for index in cards.indices {
            if cards[index].isFaceUp {
                cards[index].isMatched = true
            }
        }
    }
    
    
    private func setPenaltyForSelectedCards() {
        for index in cards.indices {
            if cards[index].isFaceUp {
                cards[index].numberOfMismatchedInvolded += 1
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card,card,card]
        }
        cards = cards.shuffled()
        flipCount = 0
    }
    
}
