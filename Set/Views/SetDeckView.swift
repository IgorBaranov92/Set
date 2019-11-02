import UIKit

class SetDeckView: UIView {

    var cardViews = [SetCardView]() { didSet {
        cardViews.forEach { addSubview($0);$0.contentMode = .redraw }
        setNeedsLayout()
    }}

    private lazy var grid = Grid(layout: .aspectRatio(Constants.setCardViewAspectRatio),                                 frame: bounds)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = cardViews.count
        grid.frame = bounds
        cardViews.forEach { cardView in
            let index = self.cardViews.firstIndex(of: cardView)!
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveLinear,
                animations: {
                    self.cardViews[index].frame = self.grid[index] ?? CGRect.zero } )
        }
    }
    
    func throwCardsOnDeck(completionHandler: @escaping ()->Void) {
        cardViews.forEach { $0.frame = CGRect(x: bounds.width, y: bounds.height, width: 0, height: 0)}
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: Double(index+1)*0.3,
                options: .curveLinear,
                animations: {self.cardViews[index].frame = self.grid[index] ?? CGRect.zero},completion:{ position in
                    if position == .end {
                        UIView.transition(with: self.cardViews[index],
                                      duration: 0.5,
                                       options: .transitionFlipFromLeft,
                                    animations: {
                                self.cardViews[index].state = .unselected
                        },completion: { completed in
                            if completed && index == self.cardViews.count - 1 {
                                completionHandler()
                            }
                        })
                    }
                })
        }
    }
    
    private struct Constants {
        static let setCardViewAspectRatio: CGFloat = 8.0/5.0
    }

}
