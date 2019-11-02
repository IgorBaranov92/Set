import UIKit

class SetGameViewController: UIViewController, GameDelegate {
    
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var matchesLabel: UILabel!
    @IBOutlet private weak var deckView: UIView!
    
    private lazy var animator = UIDynamicAnimator(referenceView: deckView)
    private lazy var wackyCardBehavior = WackyCardBehavior(in: animator)
    
    private var game = SetGame()
    lazy var grid = Grid(layout: .aspectRatio(8.0/5.0))
    private let colors = [SetCard.Color.green: UIColor.green,
                          SetCard.Color.purple: .purple,
                          SetCard.Color.red : .red
    ]
    private var cardViews = [SetCardView]()
    private var selectedCards: [SetCardView] { cardViews.filter {$0.state == .selected } }
    
    
    
    // MARK: - ViewController lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(drawThreeNewCards))
        view.addGestureRecognizer(tapGesture)
        newGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    
    // MARK: - Game process
    
    private func newGame() {
        cardViews.forEach{$0.removeFromSuperview()}
        cardViews.removeAll()
        game = SetGame()
        game.delegate = self
         for index in game.visibleCards.indices {
             addCardAt(index)
         }
        dealNewCards()
     }
    
     
     private func addCardAt(_ index: Int) {
        let cardView = SetCardView()
        cardView.amount = game.visibleCards[index].amount.rawValue
        cardView.shape = game.visibleCards[index].shape.rawValue
        cardView.filling = game.visibleCards[index].filling.rawValue
        cardView.color = colors[game.visibleCards[index].color] ?? UIColor.black
        cardView.state = .background
        cardView.contentMode = .redraw
        cardView.backgroundColor = .clear
        cardViews.append(cardView)
        deckView.addSubview(cardView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTheCard(_:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
     }
    
    
       
       @objc private func drawThreeNewCards() {
        game.draw()
        grid.cellCount = game.visibleCards.count
        grid.frame = deckView.bounds
        for index in 0 ... game.visibleCards.count - 4 {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.durationForRearrangingCards,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    self.cardViews[index].frame = self.grid[index] ?? CGRect.zero
            }) { (position) in
                if position == .end {}
            }
        }
        for index in game.visibleCards.count - 3 ... game.visibleCards.count - 1 {
            addCardAt(index)
            cardViews[index].frame.origin = CGPoint(x: view.bounds.width, y: view.bounds.height)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: .curveEaseIn,
                    animations: {
                        self.cardViews[index].frame = self.grid[index] ?? CGRect.zero
                }) { (position) in
                    if position == .end {
                        UIView.transition(with: self.cardViews[index],
                                          duration: Constants.durationForFlippingCard,
                                          options: .transitionFlipFromLeft,
                                          animations: {
                                            self.cardViews[index].state = .unselected
                        }) { completed in
                            if completed && index == self.cardViews.count - 1 {
                                self.enableUI(true)
                            }
                        }
                        
                    }
                }
            }
       }
     
        
      
    
    private func updateUI() {
        grid.cellCount = game.visibleCards.count
        grid.frame = deckView.bounds
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.durationForRearrangingCards,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    self.cardViews[index].frame = self.grid[index] ?? CGRect.zero
            }) { (position) in
                if position == .end {
                }
            }
        }
    }
    


    @objc func tapTheCard(_ gesture: UITapGestureRecognizer) {
           if gesture.state == .ended {
            if let cardView = gesture.view as? SetCardView {
                let index = cardViews.firstIndex(of: cardView)!
                cardView.frame = grid[index] ?? CGRect.zero
                cardView.state = (cardView.state == .selected) ? .unselected : .selected
                game.chooseCard(at: index)
                print("cardViewBounds = \(cardView.bounds)")
            }
           }
       }
    
    
    // MARK: - Helper functions
    
    private func updateLabels() {
        scoreLabel.text = "Scores: \(SetGame.scores)"
        matchesLabel.text = "Matches: \(game.matchesFound)"
    }
    
    
    private func enableUI(_ enable:Bool) {
        view.isUserInteractionEnabled = enable
        cardViews.forEach { $0.isUserInteractionEnabled = enable }
    }
    
    // MARK: - Protocol conformance
    
    func setWasFound() {
        print("setWasFound")
        updateLabels()
        replaceFoundCards()
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
    
    private func dealNewCards() {
        enableUI(false)
        grid.cellCount = game.visibleCards.count
        grid.frame = deckView.bounds
        cardViews.forEach { $0.frame.origin = CGPoint(x: view.bounds.width, y: view.bounds.height)}
        for index in cardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constants.durationForFlyingCard,
                delay: Double(index)/5.0,
                options: .curveEaseIn,
                animations: {
                    self.cardViews[index].frame = self.grid[index] ?? CGRect.zero
            }) { (position) in
                if position == .end {
                    UIView.transition(with: self.cardViews[index],
                                      duration: Constants.durationForFlippingCard,
                                      options: .transitionFlipFromLeft,
                                      animations: {
                                        self.cardViews[index].state = .unselected
                    }) { completed in
                        if completed && index == self.cardViews.count - 1 {
                            self.enableUI(true)
                        }
                    }
                    
                }
            }
        }
    }
    
    private func replaceFoundCards() {
        enableUI(false)
        selectedCards.forEach { cardView in
            deckView.bringSubviewToFront(cardView)
            let index = self.cardViews.firstIndex(of: cardView)!
            UIView.transition(with: cardView, duration: Constants.durationForFlippingCard, options: .transitionFlipFromLeft, animations: {
                cardView.state = .background
            }) { completed in
                if completed {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: Constants.durationForDisappiaringCard,
                        delay: 0.0,
                        options: .curveLinear,
                        animations: {
                            cardView.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height, width: 0, height: 0)
                    }) { position in
                        if position == .end {
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: Constants.durationForAppiaringCard, delay: 0.0, options: .curveLinear, animations: {
                                self.cardViews[index].frame = self.grid[index] ?? CGRect.zero
                            }) { (position) in
                                if position == .end {
                                    UIView.transition(with: self.cardViews[index], duration: Constants.durationForFlippingCard, options: .transitionFlipFromLeft, animations: {
                                        self.cardViews[index].state = .unselected
                                    }) { completed in
                                        if completed { self.enableUI(true)}
                                    }
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
    static let durationForFlyingCard = 1.5
    static let durationForShakingCard = 0.15
    static let durationForRearrangingCards = 0.5
    static let durationForResizingCard = 1.5
    static let durationForDisappiaringCard = 1.0
    static let durationForAppiaringCard = 1.0

}


