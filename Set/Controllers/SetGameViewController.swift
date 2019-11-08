import UIKit

class SetGameViewController: UIViewController, SetGameDelegate {
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var matchesLabel: UILabel!
    @IBOutlet private weak var deckView: SetDeckView!

    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private lazy var cardBehavior = CardBehavior(in: animator)
    
    private var game = SetGame()
    private var selectedCards: [SetCardView] {
        deckView.cardViews.filter {$0.state == .selected && !$0.isHidden }
    }
        
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dealThreeCards(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !deckView.deckCreated { newGame() }
    }
    
    // MARK: - Game process
    
    private func newGame() {
        game = SetGame()
        game.delegate = self
        game.visibleCards.forEach { addCardAt(game.visibleCards.firstIndex(of: $0)!) }
        enableUI(false)
        deckView.throwCardsOnDeck(completionHandler: {
            self.enableUI(true)
        })
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
    
    
       
    @objc private func dealThreeCards(_ recognizer:UITapGestureRecognizer) {
        if recognizer.state == .ended && game.deck.count > 0 {
//            enableUI(false)
            game.draw()
            for index in game.visibleCards.count - 3 ... game.visibleCards.count - 1 {
                addCardAt(index)
            }
        }
   }

    
    @objc func tapTheCard(_ gesture: UITapGestureRecognizer) {
           if gesture.state == .ended, let cardView = gesture.view as? SetCardView {
//                let index = deckView.cardViews.firstIndex(of: cardView)!
//                cardView.state = (cardView.state == .selected) ? .unselected : .selected
//            deckView.bringSubviewToFront(cardView)
            cardBehavior.addItem(cardView)
//                game.chooseCard(at: index)
           }
       }
    
    
    // MARK: - Helper function
    
    private func updateLabels() {
        scoreLabel.text = "Scores: \(SetGame.scores)"
        matchesLabel.text = "Matches: \(game.matchesFound)"
    }
    
    
    // MARK: - Protocol conformance
    
    func setWasFound() {
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
        enableUI(false)
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
                                      if position == .end {
                                        cardView.state = .unselected
                                        self.enableUI(true)
                                }
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
    static let durationForFlyingCard = 0.5
    static let durationForShakingCard = 0.1
    static let xOffset: CGFloat = 15.0
}


