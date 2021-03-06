import UIKit

class CardView: UIView {
    
    
    var state:State = .isFaceDown { didSet { setNeedsDisplay() }}

    var amount = 1 { didSet { setNeedsDisplay() }}
    var color = 1 { didSet { setNeedsDisplay() }}
    var shape = 1 { didSet {
        switch shape {
            case 1: shapeType = .diamond
            case 2: shapeType = .oval
            case 3: shapeType = .wave
        default:break
        }
        setNeedsDisplay()
        }}
    var filling = 1 { didSet {
        switch filling {
            case 1: fillingType = .full
            case 2: fillingType = .empty
            case 3: fillingType = .striped
        default:break
        }
        setNeedsDisplay()
        }}
    
    
    private var shapeType:Shape = .oval { didSet { setNeedsDisplay() }}
    private var fillingType:Filling = .empty { didSet { setNeedsDisplay() }}

    
    override func draw(_ rect: CGRect) {
        let rectPath = UIBezierPath(roundedRect: rect,cornerRadius: Constants.cardCornerRadius)
        UIColor.white.setFill()
        rectPath.fill()
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = state == .isFaceDown ? UIColor.clear.cgColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) 
        layer.cornerRadius = Constants.cardCornerRadius
        rectPath.addClip()
        switch state {
        case .selected:
            let path = UIBezierPath(roundedRect: rect,cornerRadius: Constants.cardCornerRadius)
            #colorLiteral(red: 0.9524742046, green: 0.9764705896, blue: 0.5681928202, alpha: 1).setFill()
            path.fill()
            fallthrough
        case .unselected:
            drawCardView()
        case .isFaceDown:
            if let cardBackground = UIImage(named: "SetBackground") {
            cardBackground.draw(in: rect)
        }
        case .hinted:
            layer.borderWidth = Constants.layerBorderWidth
            layer.borderColor = UIColor.blue.cgColor
            drawCardView()
        }
        
    }
    
    private func drawCardView() {
        let shapePath = UIBezierPath()
        let cardColor = colors[color - 1]
        shapePath.lineWidth = Constants.lineWidthForShape
        if let centers = centers[amount] {
            for i in centers.indices {
                let center = centers[i]
                switch shapeType {
                case .diamond:
                    shapePath.move(to: CGPoint(x: center - 0.12*bounds.width, y: bounds.midY))
                    shapePath.addLine(to: CGPoint(x: center, y: 0.1*bounds.height))
                    shapePath.addLine(to: CGPoint(x: center + 0.12*bounds.width, y: bounds.midY))
                    shapePath.addLine(to: CGPoint(x: center, y: 0.9*bounds.height))
                    shapePath.close()
                case .oval:
                    shapePath.move(to: CGPoint(x: center + 0.2*bounds.height, y: 0.25*bounds.height))
                    shapePath.addArc(withCenter: CGPoint(x: center, y: 0.25*bounds.height),
                                     radius: 0.2*bounds.height,
                                     startAngle: 0,
                                     endAngle: .pi,
                                     clockwise: false)
                    shapePath.addLine(to: CGPoint(x: center - 0.2*bounds.height, y: 0.75*bounds.height))
                    shapePath.addArc(withCenter: CGPoint(x: center, y: 0.75*bounds.height),
                                     radius: 0.2*bounds.height,
                                     startAngle: .pi,
                                     endAngle: 0,
                                     clockwise: false)
                    shapePath.addLine(to: CGPoint(x: center + 0.2*bounds.height, y: 0.25*bounds.height))
                case .wave:
                    shapePath.move(to: CGPoint(x: center - 0.1*bounds.width, y: 0.1*bounds.height))
                    shapePath.addLine(to: CGPoint(x: center + 0.1*bounds.width, y: 0.1*bounds.height))
                    shapePath.addCurve(to: CGPoint(x: center + 0.1*bounds.width, y: 0.9*bounds.height),
                                       controlPoint1: CGPoint(x: center + 0.2*bounds.width, y: 0.4*bounds.height),
                                       controlPoint2: CGPoint(x: center, y: 0.5*bounds.height))
                    shapePath.addLine(to: CGPoint(x: center - 0.1*bounds.width, y: 0.9*bounds.height))
                    shapePath.addCurve(to: CGPoint(x: center - 0.1*bounds.width, y: 0.1*bounds.height),
                                       controlPoint1: CGPoint(x: center - 0.2*bounds.width, y: 0.6*bounds.height),
                                       controlPoint2: CGPoint(x: center, y: 0.5*bounds.height))
                }
                
            }
        }
        switch fillingType {
        case .full:
            cardColor.setFill()
            shapePath.fill()
        case .striped:
            shapePath.addClip()
            for dx in stride(from: 0.0, to: bounds.width, by: bounds.width/30) {
                let verticalLinePath = UIBezierPath()
                verticalLinePath.move(to: CGPoint(x: dx, y: 0))
                verticalLinePath.addLine(to: CGPoint(x: dx, y: bounds.height))
                verticalLinePath.lineWidth = Constants.lineWidthForVerticalLines
                cardColor.setStroke()
                verticalLinePath.stroke()
            }
            fallthrough
        case .empty:
            cardColor.setStroke()
            shapePath.stroke()
        }
    }
    
    private var centers: [Int:[CGFloat]]  {
       [ 1: [bounds.midX],
        2: [0.35*bounds.width,0.65*bounds.width],
        3: [0.23*bounds.width,bounds.midX,0.77*bounds.width]
    ]
    }
    
    private var colors: [UIColor] {
        [.purple,.red,.green]
    }
    
    enum State {
       case selected
       case unselected
       case isFaceDown
       case hinted
    }
    
    enum Shape {
        case diamond
        case oval
        case wave
    }
    enum Filling {
        case full
        case empty
        case striped
    }
    
    private struct Constants {
        static let lineWidthForShape: CGFloat = 2.0
        static let lineWidthForVerticalLines: CGFloat = 0.5
        static let cardCornerRadius: CGFloat = 16.0
        static let borderWidth: CGFloat = 1.0
        static let layerBorderWidth: CGFloat = 3.0
    }
    
}



