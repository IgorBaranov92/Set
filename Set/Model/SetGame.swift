import Foundation

class SetGame {
    
    weak var delegate: GameDelegate?
    static private(set) var scores = 0

    private(set) var deck = [SetCard]()
    private(set) var visibleCards = [SetCard]()
    private(set) var matchesFound = 0
    private var foundIndexes = [Int]()
    private var selectedCards = [SetCard]()

    init() {
        selectedCards.removeAll()
        foundIndexes.removeAll()
        matchesFound = 0
        visibleCards.removeAll()
        for color in SetCard.Color.allCases {
            for filling in SetCard.Filling.allCases {
                for shape in SetCard.Shape.allCases {
                    for amount in SetCard.Amount.allCases {
                        let card = SetCard(color: color, filling: filling, amount: amount, shape: shape)
                        deck.append(card)
                    }
                }
            }
        }
        for _ in 0...3 { draw() }
    }
    
    
    func draw() {
        if deck.count > 0 {
            for _ in 0...2 {
                visibleCards.append(deck.removeRandomElement())
            }
        }
    }
    
    func chooseCard(at index:Int) {
        if foundIndexes.contains(index) {
            if foundIndexes.count == 1 { foundIndexes.removeFirst();selectedCards.removeFirst() }
            if foundIndexes.count == 2 {
                if index == foundIndexes.first! { foundIndexes.removeFirst();selectedCards.removeFirst()}
                if index == foundIndexes.last! { foundIndexes.removeLast();selectedCards.removeLast() }
            }
            SetGame.scores -= 1
            delegate?.deselectCard()
        } else {
            selectedCards.append(visibleCards[index])
            foundIndexes.append(index)
            if selectedCards.count == 3 { checkIfThreeSelectedCardsAreSet() }
        }
    }
    
    
    private func checkIfThreeSelectedCardsAreSet() {
//        let colors = Set(selectedCards.map{$0.color}).count
//        let amount = Set(selectedCards.map{$0.amount}).count
//        let filling = Set(selectedCards.map{$0.filling}).count
//        let shape = Set(selectedCards.map{$0.shape}).count
        if 2 > 1 { // three cards are set
            SetGame.scores += 5
            matchesFound += 1
            if deck.count > 0 {
                for i in 0...2 {
                    let indexToReplace = foundIndexes[i]
                    visibleCards.remove(at: indexToReplace)
                    visibleCards.insert(deck.removeRandomElement(), at: indexToReplace)
                }
                delegate?.setWasFound()
            } else {
                delegate?.gameFinished()
            }
        } else { // three cards are not set
//            SetGame.scores -= 3
//            delegate?.setNotFound()
        }
        print(deck.count)
        foundIndexes.removeAll()
        selectedCards.removeAll()
    }
    
}


