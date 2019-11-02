import UIKit

class SetGameViewController: UIViewController, GameDelegate {
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var matchesLabel: UILabel!
    @IBOutlet private weak var deckView: SetDeckView!

    private var grid = Grid(layout: .aspectRatio(8.0/5.0))
    private var game = SetGame()
    private var selectedCards: [SetCardView] { deckView.setCardViews.filter {$0.state == .selected } }
        
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(drawThreeNewCards))
        view.addGestureRecognizer(tapGesture)
        newGame()
    }
    
    
    // MARK: - Game process
    
    private func newGame() {
        game = SetGame()
        game.delegate = self
         for index in game.visibleCards.indices {
             addCardAt(index)
         }
     }
    
     
    private func addCardAt(_ index: Int) {
        let cardView = SetCardView()
        cardView.amount = game.visibleCards[index].amount.rawValue
        cardView.shape = game.visibleCards[index].shape.rawValue
        cardView.filling = game.visibleCards[index].filling.rawValue
        cardView.color = game.visibleCards[index].color.rawValue
        cardView.state = .isFaceDown
        cardView.contentMode = .redraw
        cardView.backgroundColor = .clear
        deckView.setCardViews.append(cardView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTheCard(_:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
       
    @objc private func drawThreeNewCards() {
    game.draw()
    }

    
    @objc func tapTheCard(_ gesture: UITapGestureRecognizer) {
           if gesture.state == .ended {
            if let cardView = gesture.view as? SetCardView {
                let index = deckView.setCardViews.firstIndex(of: cardView)!
                cardView.frame = grid[index] ?? CGRect.zero
                cardView.state = (cardView.state == .selected) ? .unselected : .selected
                game.chooseCard(at: index)
            }
           }
       }
    
    
    // MARK: - Helper functions
    
    private func updateLabels() {
        scoreLabel.text = "Scores: \(SetGame.scores)"
        matchesLabel.text = "Matches: \(game.matchesFound)"
    }
    
    
    // MARK: - Protocol conformance
    
    func setWasFound() {
        print("setWasFound")
        updateLabels()
//        replaceFoundCards()
    }
    
    func deselectCard() {
        updateLabels()
    }
    
    func setNotFound() {
        updateLabels()
        shakeSelectedCards()
    }
    
    func gameFinished() {
        
    }
}


extension SetGameViewController {
    
    private func shakeSelectedCards() {
        selectedCards.forEach { cardView in
            let origin = cardView.frame.origin
      UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: Constants.durationForShakingCard,
          delay: 0.0,
          options: .curveLinear ,
          animations: {
           cardView.frame.origin.x -= 10
      })
      { (position) in
          if position == .end {
              UIViewPropertyAnimator.runningPropertyAnimator(
                  withDuration: Constants.durationForShakingCard,
                  delay: 0.0,
                  options: .curveLinear,
                  animations:
               {   cardView.frame.origin.x += 20

              })
              { (position) in
                      if position == .end {
                          UIViewPropertyAnimator.runningPropertyAnimator(
                              withDuration: Constants.durationForShakingCard,
                              delay: 0.0,
                              options: .curveLinear,
                              animations: {
                               cardView.frame.origin = origin
                          })
                          { (position) in
                                  if position == .end {cardView.state = .unselected }
                          }
                      }
              }
          }
      }
               }

          }

}



fileprivate struct Constants {
    static let durationForFlippingCard = 0.5
    static let durationForFlyingCard = 1.5
    static let durationForShakingCard = 0.15
    static let durationForRearrangingCards = 0.5
    static let durationForResizingCard = 1.5
    static let durationForDisappiaringCard = 1.0
    static let durationForAppiaringCard = 1.0

}


