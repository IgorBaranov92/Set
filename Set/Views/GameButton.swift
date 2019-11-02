import UIKit

class GameButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        titleLabel?.numberOfLines = 0
        titleLabel?.minimumScaleFactor = 0.01
    }
    
}
