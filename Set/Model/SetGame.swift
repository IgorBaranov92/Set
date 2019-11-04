import Foundation

class SetGame {
    
    weak var delegate: GameDelegate?
    static private(set) var scores = 0

    private(set) var deck = [SetCard]()
    private(set) var visibleCards = [SetCard]()
    private(set) var matchesFound = 0
    private var selectedCards:[SetCard] { visibleCards.filter { $0.isSelected } }
    
    init() {
        matchesFound = 0
        visibleCards.removeAll()
        for color in SetCard.Option.allCases {
            for filling in SetCard.Option.allCases {
                for shape in SetCard.Option.allCases {
                    for amount in SetCard.Option.allCases {
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
        if visibleCards[index].isSelected {
            visibleCards[index].isSelected = false
            SetGame.scores -= Points.penaltyForDeselection
            delegate?.deselectCard()
        } else {
            visibleCards[index].isSelected = true
            if selectedCards.count == 3 { checkIfThreeSelectedCardsAreSet() }
        }
    }
    
    
    private func checkIfThreeSelectedCardsAreSet() {
        if isSet {
            let penalty = selectedCards.map { Int($0.numberOfMismatchedInvolved) }
                                       .reduce(0) { x,y in x + y}
            SetGame.scores += Points.setWasFound - penalty
            matchesFound += 1
            if deck.count > 0 {
                for i in 0...2 {
                    let indexToReplace = visibleCards.firstIndex(of: selectedCards[i])!
                    visibleCards.remove(at: indexToReplace)
                    
                }
                delegate?.setWasFound()
            } else {
                delegate?.gameFinished()
            }
        } else { 
            SetGame.scores -= Points.setWasNotFound
            delegate?.setNotFound()
        }
        for index in visibleCards.indices {
            visibleCards[index].isSelected = false
            visibleCards[index].numberOfMismatchedInvolved += 1
        }
    }
    
    private var isSet: Bool {
        let colors = Set(selectedCards.map{$0.color}).count
        let amount = Set(selectedCards.map{$0.amount}).count
        let filling = Set(selectedCards.map{$0.filling}).count
        let shape = Set(selectedCards.map{$0.shape}).count
        return (colors != 2 && amount != 2 && filling != 2 && shape != 2)
    }
    
    private func findThreeSetCardsIfPossible() {
        SetGame.scores -= Points.penaltyForHint
        
    }
    
    
    private struct Points {
        static let penaltyForHint = 10
        static let penaltyForDeselection = 1
        static let setWasFound = 5
        static let setWasNotFound = 3
        
    }
    
}



