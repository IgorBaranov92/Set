import UIKit


class ShakeAnimation {
    
    static func shake(view:UIView,completion:@escaping () -> Void) {
        let origin = view.frame.origin
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Constants.durationShakingCard,
                   delay: 0.0,
                 options: .curveLinear ,
              animations: { view.frame.origin.x -= Constants.xOffset })
        { if $0 == .end {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: Constants.durationShakingCard,
                           delay: 0.0,
                         options: .curveLinear,
                      animations:
                 {   view.frame.origin.x += Constants.xOffset * 2 })
                { if $0 == .end {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: Constants.durationShakingCard,
                                       delay: 0.0,
                                     options: .curveLinear,
                                  animations: { view.frame.origin = origin })
                            { if $0 == .end { completion() } }
                      }
                }
            }
        }
    }
    
}
