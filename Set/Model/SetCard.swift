import Foundation


struct SetCard {

    private(set) var color: Option
    private(set) var filling: Option
    private(set) var amount: Option
    private(set) var shape : Option
    var numberOfMismatchedInvolved = 0
    var isSelected = false
    
    
    enum Option: Int,CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
    
    var oppositeValue: Option {
        return .one
    }
   
    
}

extension SetCard: Equatable {
    static func ==(lhs:SetCard,rhs:SetCard) -> Bool {
        return (lhs.amount == rhs.amount) && (lhs.color == rhs.color) && (lhs.filling == rhs.filling) && (lhs.shape == rhs.shape)
    }
}

