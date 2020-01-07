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
        if deckCreated {
            grid.cellCount = cardViews.count
            grid.bounds = bounds
            cardViews.forEach { cardView in
                let index = self.cardViews.firstIndex(of: cardView)!
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: Constants.durationForRearrangingCards,
                           delay: 0.0,
                         options: .curveLinear,
                      animations:{self.cardViews[index].frame = self.grid[index] ?? CGRect.zero },
                    completion: {
                        if $0 == .end && self.cardViews[index].state == .isFaceDown && self.deckCreated {
                                UIView.transition(
                                    with: self.cardViews[index],
                                duration: Constants.durationForFlippingCard,
                                 options: .transitionFlipFromLeft,
                              animations: { self.cardViews[index].state = .unselected })
                            }
                })
            }
        }
        
    }
    
    func throwCardsOnDeck(completionHandler: @escaping ()->Void) {
        grid.cellCount = cardViews.count
        grid.bounds = bounds
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Constants.durationForThrowingCard,
                   delay: Double(index+1)*0.2,
                 options: .curveLinear,
              animations: {self.cardViews[index].frame = self.grid[index] ?? CGRect.zero},
              completion:{ if $0 == .end {
                        UIView.transition(with: self.cardViews[index],
                            duration: Constants.durationForFlippingCard,
                             options: .transitionFlipFromLeft,
                          animations: { self.cardViews[index].state = .unselected },
                          completion: { completed in
                            if completed && index == self.cardViews.count - 1 {
                                self.deckCreated = true
                                completionHandler()
                            }
                        })
                    }
                })
        }
    }
    

}


