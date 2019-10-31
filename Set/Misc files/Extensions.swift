import Foundation
import UIKit

extension Array {
    mutating func removeRandomElement() -> Element {
        return remove(at: Int.random(in: 0..<self.count))
    }
}


protocol GameDelegate: class {
    func setWasFound()
    func setNotFound()
    func deselectCard()
    func gameFinished()
}

extension CGAffineTransform {
    func scaledBy(_ dxy:CGFloat) -> CGAffineTransform {
        return scaledBy(x: dxy, y: dxy)
    }
}

extension UIView {
    func scaleSizeBy(_ ratio: CGFloat) {
        frame.size = CGSize(width: bounds.width*ratio, height: bounds.height*ratio)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGPoint {
    func moveToBy(_ dx:CGFloat,_ dy:CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension UIViewController {
    var content: UIViewController {
        if let navController = self as? UINavigationController {
            return navController.visibleViewController ?? self
        }
        return self
    }
}

var isPotraitOrientation: Bool {
    return (UIDevice.current.orientation == .portraitUpsideDown || UIDevice.current.orientation == .portrait)
}

var isLandscapeOrientation: Bool {
    return (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight)
}
