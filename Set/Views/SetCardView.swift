import UIKit


class SetCardView: UIView {

    var amount = 1 { didSet { setNeedsDisplay() }}
    var color = 1 { didSet { setNeedsDisplay() }}
    var shape = 1 { didSet {
        switch shape {
            case 1: shapeType = .diamond
            case 2: shapeType = .oval
            case 3: shapeType = .wave
        default:break
        }
        }}
    var filling = 1 { didSet {
        switch shape {
            case 1: fillingType = .full
            case 2: fillingType = .empty
            case 3: fillingType = .striped
        default:break
        }
        }}
    
    private var shapeType:Shape = .oval { didSet { setNeedsDisplay() }}
    private var fillingType:Filling = .empty { didSet { setNeedsDisplay() }}
    var state:State = .isFaceDown { didSet { setNeedsDisplay() }}

    
    
    override func draw(_ rect: CGRect) {
        let rectPath = UIBezierPath(roundedRect: rect,cornerRadius: Constants.cardCornerRadius)
        let cardColor = colors[color - 1]
        UIColor.white.setFill()
        rectPath.fill()
        layer.borderWidth = 1.0
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.cornerRadius = Constants.cardCornerRadius
        switch state {
        case .selected:
            let path = UIBezierPath(roundedRect: rect,cornerRadius: Constants.cardCornerRadius)
            #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).setFill()
            path.fill()
            fallthrough
        case .unselected:
            let shapePath = UIBezierPath()
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
        case .isFaceDown:
        if let cardBackground = UIImage(named: "SetBackground") {
            cardBackground.draw(in: rect)
        }
        case .hinted:
            let path = UIBezierPath(rect: rect)
            #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
            path.fill()
            layer.borderWidth = 5.0
            layer.borderColor = UIColor.blue.cgColor
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
    }
    
}



