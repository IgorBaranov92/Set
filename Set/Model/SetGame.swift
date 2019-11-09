import Foundation

class SetGame {
    
    weak var delegate: SetGameDelegate?
    static private(set) var scores = 0

    private(set) var deck = [SetCard]()
    private(set) var visibleCards = [SetCard]()
    private(set) var matchesFound = 0
    private var selectedCards:[SetCard] { visibleCards.filter { $0.isSelected } }
    private var penalty: Int {
        selectedCards.map { Int($0.numberOfMismatchedInvolved) }
                     .reduce(0) { $0 + $1 }
    }
    
    init() {
        matchesFound = 0
        visibleCards.removeAll()
        deck.removeAll()
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
            visibleCards[index].numberOfMismatchedInvolved += 1
            delegate?.deselectCard()
        } else {
            visibleCards[index].isSelected = true
            if selectedCards.count == 3 { checkIfThreeSelectedCardsAreSet() }
        }
    }
    
    
    private func checkIfThreeSelectedCardsAreSet() {
        if isSet {
            SetGame.scores += Points.setWasFound - penalty
            matchesFound += 1
            if deck.count > 0 {
                for i in stride(from: 2, to: -1, by: -1) {
                    let indexToReplace = visibleCards.firstIndex(of: selectedCards[i])!
                    visibleCards.remove(at: indexToReplace)
                    visibleCards.insert(deck.removeRandomElement(), at: indexToReplace)
                }
                delegate?.setWasFound()
            } else {
                delegate?.gameFinished()
            }
        } else { 
            SetGame.scores -= (Points.setWasNotFound + penalty)
            delegate?.setNotFound()
        }
        for index in visibleCards.indices {
            visibleCards[index].isSelected = false
        }
    }
    
    private var isSet: Bool {
//        let colors = Set(selectedCards.map{$0.color}).count
//        let amount = Set(selectedCards.map{$0.amount}).count
//        let filling = Set(selectedCards.map{$0.filling}).count
//        let shape = Set(selectedCards.map{$0.shape}).count
//        return (colors != 2 && amount != 2 && filling != 2 && shape != 2)
        return 2 > 1
    }
    
    private func findThreeSetCardsIfPossible() {
        SetGame.scores -= Points.penaltyForHint
        
    }
    
    private func foundSetCardFor(_ firstCard:SetCard,_ secondCard:SetCard) -> SetCard {
        let colorRawValue = firstCard.color.rawValue^secondCard.color.rawValue == 0 ? firstCard.color.rawValue : firstCard.color.rawValue^secondCard.color.rawValue
        let shapeRawValue = firstCard.shape.rawValue^secondCard.shape.rawValue == 0 ? firstCard.shape.rawValue : firstCard.shape.rawValue^secondCard.shape.rawValue
        let fillingRawValue = firstCard.filling.rawValue^secondCard.filling.rawValue == 0 ? firstCard.filling.rawValue : firstCard.filling.rawValue^secondCard.filling.rawValue
        let amountRawValue = firstCard.amount.rawValue^secondCard.amount.rawValue == 0 ? firstCard.amount.rawValue : firstCard.amount.rawValue^secondCard.amount.rawValue
        return SetCard(color: SetCard.Option(rawValue: colorRawValue)!,
                       filling: SetCard.Option(rawValue: fillingRawValue)!,
                       amount: SetCard.Option(rawValue: amountRawValue)!,
                       shape: SetCard.Option(rawValue: shapeRawValue)!
        )
    }

    
    private struct Points {
        static let penaltyForHint = 10
        static let penaltyForDeselection = 1
        static let setWasFound = 5
        static let setWasNotFound = 3
        
    }
    
}



