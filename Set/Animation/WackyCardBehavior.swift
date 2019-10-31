import UIKit

class WackyCardBehavior: UIDynamicBehavior {


    
    private var dynamicItemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.resistance = 1.0
        return behavior
    }()
    
    private var collisionBehavior: UICollisionBehavior = {
        let collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()
    
    
    
    override init() {
        super.init()
        addChildBehavior(dynamicItemBehavior)
        addChildBehavior(collisionBehavior)
    }
    
    
    
    func addItem(_ item: UIDynamicItem) {
        dynamicItemBehavior.addItem(item)
        collisionBehavior.addItem(item)
//        let snap = UISnapBehavior(item: item, snapTo: CGPoint(x: 100, y: 100))
//        addChildBehavior(snap)
//        snap.damping = 0.7
//        snap.snapPoint = CGPoint(x: 150, y: 150)
//        snap.action = {
//            self.dynamicAnimator?.removeBehavior(snap)
//        }
        let push = UIPushBehavior(items: [item], mode: .continuous)
        push.angle = CGFloat.random(in: 0...CGFloat.pi*2)
        push.magnitude = 1.5
        addChildBehavior(push)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
}
