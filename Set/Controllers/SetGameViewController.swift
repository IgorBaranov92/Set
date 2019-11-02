import UIKit

class SetGameViewController: UIViewController, GameDelegate {
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var matchesLabel: UILabel!
    @IBOutlet private weak var deckView: SetDeckView!

    private var grid = Grid(layout: .aspectRatio(8.0/5.0))
    private var game = SetGame()
    private var selectedCards: [SetCardView] { deckView.cardViews.filter {$0.state == .selected } }
        
    // MARK: - ViewController lifecycle

    private var gameCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(drawThreeNewCards))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !gameCreated {
            newGame()
            gameCreated = true
        }
    }
    
    // MARK: - Game process
    
    private func newGame() {
        game = SetGame()
        game.delegate = self
         for index in game.visibleCards.indices {
             addCardAt(index)
         }
        enableUI(false)
        deckView.throwCardsOnDeck(completionHandler: {self.enableUI(true)} )
     }
    
     
    private func addCardAt(_ index: Int) {
        let cardView = SetCardView(frame: CGRect(x: deckView.bounds.width, y: deckView.bounds.height, width: 0, height: 0))
        cardView.amount = game.visibleCards[index].amount.rawValue
        cardView.shape = game.visibleCards[index].shape.rawValue
        cardView.filling = game.visibleCards[index].filling.rawValue
        cardView.color = game.visibleCards[index].color.rawValue
        cardView.state = .isFaceDown
        cardView.backgroundColor = .clear
        deckView.cardViews.append(cardView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTheCard(_:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
       
    @objc private func drawThreeNewCards() {
        if game.visibleCards.count > 0 {
            game.draw()
            for index in game.visibleCards.count - 3 ... game.visibleCards.count - 1 {
                addCardAt(index)
            }
        }
    }

    
    @objc func tapTheCard(_ gesture: UITapGestureRecognizer) {
           if gesture.state == .ended {
            if let cardView = gesture.view as? SetCardView {
                let index = deckView.cardViews.firstIndex(of: cardView)!
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
    
    private func enableUI(_ isUserInteractionEnabled: Bool) {
        deckView.cardViews.forEach { $0.isUserInteractionEnabled = isUserInteractionEnabled }
        view.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    private func shakeSelectedCards() {
        selectedCards.forEach { cardView in
            let origin = cardView.frame.origin
      UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: Constants.durationForShakingCard,
          delay: 0.0,
          options: .curveLinear ,
          animations: {
            cardView.frame.origin.x -= Constants.xOffset
      })
      { (position) in
          if position == .end {
              UIViewPropertyAnimator.runningPropertyAnimator(
                  withDuration: Constants.durationForShakingCard,
                  delay: 0.0,
                  options: .curveLinear,
                  animations:
               {   cardView.frame.origin.x += Constants.xOffset * 2

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
    static let durationForShakingCard = 0.1
    static let xOffset: CGFloat = 15.0
}


