import UIKit

class DeckView: UIView {

    private(set) var deckCreated = false
    
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
        grid.bounds = bounds
        cardViews.forEach { cardView in
            let index = self.cardViews.firstIndex(of: cardView)!
            if cardView.state == .hinted {cardView.state = .unselected}
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
        }
    }
    
    


}


