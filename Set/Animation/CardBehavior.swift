import UIKit

class CardBehavior: UIDynamicBehavior {

    
   private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = false
        return behavior
    }()

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 0.8
        behavior.resistance = 0.1
        return behavior
    }()
    

    
    private func push(_ item:UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.random(in: 0...CGFloat.pi*2)
        push.magnitude = 10.0
        push.action = { [unowned push,weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    
    convenience init(in animator:UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
   
    
}
