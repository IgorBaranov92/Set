import Foundation


struct Card: Codable {

    private(set) var color: Option
    private(set) var filling: Option
    private(set) var amount: Option
    private(set) var shape : Option
    
    var numberOfMismatchedInvolved = 0
    var isSelected = false
    var isHinted = false
    
    enum Option: Int,CaseIterable, Codable {
        case one = 1
        case two = 2
        case three = 3
    }
    
}

extension Card: Equatable {
    static func ==(lhs:Card,rhs:Card) -> Bool {
        return (lhs.amount == rhs.amount) && (lhs.color == rhs.color) && (lhs.filling == rhs.filling) && (lhs.shape == rhs.shape)
    }
}

