import UIKit

class Circle: UIView {

    var percent:CGFloat = 0 { didSet { setNeedsDisplay() }}
    
    private var countLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        let endAngle = -.pi/2+percent*CGFloat.pi/50
        let path = UIBezierPath(arcCenter: rect.center, radius: rect.width/2-5.0, startAngle: CGFloat.pi*3/2, endAngle:endAngle , clockwise: false)
        path.lineWidth = 3.0
        UIColor.orange.setStroke()
        path.stroke()
        countLabel.text = "\((5-Int(percent)/20))"
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        countLabel = UILabel(frame: CGRect(x: bounds.midX-30, y: bounds.midY-30, width: 60, height: 60))
        countLabel.font = UIFont(name: "Helvetica", size: 70)
        countLabel.textAlignment = .center
        countLabel.text = "\(5-percent/20)"
        addSubview(countLabel)
        let infoLabel = UILabel(frame: CGRect(x: 0, y: bounds.midX-60, width: bounds.width, height: 30))
        infoLabel.font = UIFont(name: "Helvetica", size: 20)
        infoLabel.textAlignment = .center
        infoLabel.text = "Новая игра через:"
        infoLabel.numberOfLines = 0
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.minimumScaleFactor = 0.1
        addSubview(infoLabel)
        let victoryLabel = UILabel(frame: CGRect(x: 0, y: bounds.midX-110, width: bounds.width, height: 50))
        victoryLabel.font = UIFont(name: "Helvetica", size: 40)
        victoryLabel.textAlignment = .center
        victoryLabel.text = "Победа!!!"
        addSubview(victoryLabel)
    }
    
    func startAnimating(completion:@escaping ()->Void) {
        Timer.scheduledTimer(withTimeInterval: 5/100, repeats: true) { timer in
            self.percent += 1
            if self.percent == 100 {
                timer.invalidate()
                self.percent = 0
                completion()
            }
        }
        
    }
    
    
}



