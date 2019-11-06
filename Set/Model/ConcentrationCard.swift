import Foundation

struct ConcentrationCard: CustomStringConvertible {
    
    var isFaceUp = false
    var isMatched = false
    var alreadySeen = false
    
    var numberOfMismatchedInvolded = 0
    
    private(set) var identifier: Int
    static private var id = 1
    var description: String { String(identifier) }
    
    init() {
        identifier = ConcentrationCard.id
        ConcentrationCard.id += 1
    }
}

extension ConcentrationCard: Hashable {
    static func ==(lhs:ConcentrationCard,rhs:ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        
    }
}
