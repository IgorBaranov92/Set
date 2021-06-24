import UIKit

class DeckView: UIView {

    var deckCreated = false
    
    var cardViews = [CardView]() { didSet {
        cardViews.forEach {
            addSubview($0)
            $0.contentMode = .redraw
        }
    }}

    private lazy var grid = Grid(layout: .aspectRatio(Constants.setCardViewAspectRatio),                                 frame: bounds)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = cardViews.count
        grid.frame = bounds
        cardViews.forEach { cardView in
            let index = self.cardViews.firstIndex(of: cardView)!
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.durationForRearrangingCards,
                delay: 0.0,
                options: .curveLinear,
                animations: {
                    self.cardViews[index].frame = self.grid[index] ?? CGRect.zero },completion: { position in
                        if position == .end && self.cardViews[index].state == .isFaceDown && self.deckCreated {
                            UIView.transition(
                                with: self.cardViews[index],
                                duration: Constants.durationForFlippingCard,
                                options: .transitionFlipFromLeft,
                                animations: {
                                    self.cardViews[index].state = .unselected
                            }
                            )
                        }
            })
        }
    }
    
    func throwCardsOnDeck(completionHandler: @escaping ()->Void) {
        cardViews.forEach { $0.frame = CGRect(x: bounds.width, y: bounds.height, width: 0, height: 0)}
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.durationForFlyingCard,
                delay: Double(index+1)*0.2,
                options: .curveLinear,
                animations: {self.cardViews[index].frame = self.grid[index] ?? CGRect.zero},completion:{ position in
                    if position == .end {
                        UIView.transition(with: self.cardViews[index],
                                      duration: Constants.durationForFlippingCard,
                                       options: .transitionFlipFromLeft,
                                    animations: {
                                self.cardViews[index].state = .unselected
                        },completion: { completed in
                            if completed && index == self.cardViews.count - 1 {
                                self.deckCreated = true
                                completionHandler()
                            }
                        })
                    }
                })
        }
    }
    
    func removeSelectedCards() {
        cardViews.filter {$0.state == .selected}
                 .forEach { cardView in
            
            print(cardView)
        }
    }
    
    
    private struct Constants {
        static let setCardViewAspectRatio: CGFloat = 8.0/5.0
        static let durationForRearrangingCards = 0.5
        static let durationForFlippingCard = 0.5
        static let durationForFlyingCard = 1.0
    }

}


