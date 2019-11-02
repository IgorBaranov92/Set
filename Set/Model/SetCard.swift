import Foundation


struct SetCard {

    private(set) var color: Option
    private(set) var filling: Option
    private(set) var amount: Option
    private(set) var shape : Option
    var numberOfMismatchedInvolved = 0
    
    enum Option: Int,CaseIterable {
        case one = 1
        case two
        case three
    }
    
   
    
}

extension SetCard: Equatable {
    static func ==(lhs:SetCard,rhs:SetCard) -> Bool {
        return (lhs.amount == rhs.amount) && (lhs.color == rhs.color) && (lhs.filling == rhs.filling) && (lhs.shape == rhs.shape)
    }
}

