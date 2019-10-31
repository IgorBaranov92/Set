import UIKit

class CardBehavior: UIDynamicBehavior {

    
    var collisionBehavior: UICollisionBehavior = {
        let collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()
    
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
    }
    
    convenience init(in animator:UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        snap(item)
    }

    
    private func snap(_ item: UIDynamicItem) {
        print("snap")
        let snapBehavior = UISnapBehavior(item: item, snapTo: CGPoint(x: 20.0, y: 20.0))
        snapBehavior.damping = 1.0
        snapBehavior.action = {
            print("snap")
        }
    }
    
   
    
}
