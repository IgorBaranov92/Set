import Foundation

struct ConcentrationCard: CustomStringConvertible {
    
    var isFaceUp = false
    var isMatched = false
    
    var description: String { String(identifier)}
    
    var numberOfMismatchedInvolded = -1
    
    private(set) var identifier: Int
    static private var id = 1
    
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
