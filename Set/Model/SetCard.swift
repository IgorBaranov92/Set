import Foundation


struct SetCard: CustomStringConvertible {
    
    var description: String {
        return "\(amount.rawValue) \(color.rawValue) \(filling.rawValue) \(shape.rawValue)"
    }

    private(set) var color: Color
    private(set) var filling: Filling
    private(set) var amount: Amount
    private(set) var shape : Shape
        
    enum Color: String, CaseIterable {
        case purple
        case red
        case green
    }
    
    enum Filling: String, CaseIterable {
        case full = "full"
        case empty = "empty"
        case strip = "strip"
    }
    
    enum Amount: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum Shape: String, CaseIterable {
        case diamond = "diamond"
        case wave = "wave"
        case oval = "oval"
    }
    
}

extension SetCard: Equatable {
    static func ==(lhs:SetCard,rhs:SetCard) -> Bool {
        return (lhs.amount == rhs.amount) && (lhs.color == rhs.color) && (lhs.filling == rhs.filling) && (lhs.shape == rhs.shape)
    }
}

