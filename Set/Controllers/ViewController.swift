import UIKit

class ViewController: UIViewController {

    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBOutlet weak var customView: UIView! { didSet {
        customView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(push(_:))))
        }}
    
    @IBOutlet weak var customView1: UIView!
    @IBOutlet weak var customView2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardBehavior.snapPoint = view.center
    }
    
    @objc func push(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            cardBehavior.addItem(customView)
            cardBehavior.addItem(customView1)
            cardBehavior.addItem(customView2)
        }
    }

}
