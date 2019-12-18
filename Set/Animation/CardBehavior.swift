import UIKit

class CardBehavior: UIDynamicBehavior {

    var snapPoint = CGPoint()
    
    override init() {
        super.init()
        addChildBehavior(itemBehavior)
        addChildBehavior(collisionBehavior)
    }
    
    
    convenience init(in animator:UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    func addItem(_ item: UIDynamicItem) {
        itemBehavior.addItem(item)
        collisionBehavior.addItem(item)
        push(item)
//        snap(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    
    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        behavior.collisionMode = .boundaries
        return behavior
    }()

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    
    private func push(_ item:UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.random(in: .pi/2...CGFloat.pi*2)
        push.magnitude = 30
        print(push.angle)
        push.action = { [unowned push,weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    private func snap(_ item:UIDynamicItem) {
        let snapBehavior = UISnapBehavior(item: item, snapTo: snapPoint)
        snapBehavior.damping = 1
        print("Snap Point = \(snapPoint)")
        snapBehavior.action = { [unowned snapBehavior,weak self] in
//            self?.removeChildBehavior(snapBehavior)
            self?.removeItem(item)
        }
        addChildBehavior(snapBehavior)
    }
    
    
    
    
   
    
}
