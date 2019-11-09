import Foundation
import UIKit

extension Array {
    mutating func removeRandomElement() -> Element {
        return remove(at: Int.random(in: 0..<self.count))
    }
}

protocol SetGameDelegate: class {
    func setWasFound()
    func setNotFound()
    func deselectCard()
    func gameFinished()
}


extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

var isPotraitOrientation: Bool {
    return (UIDevice.current.orientation == .portraitUpsideDown || UIDevice.current.orientation == .portrait)
}

var isLandscapeOrientation: Bool {
    return (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight)
}
