import UIKit

class SetGameViewController: UIViewController, SetGameDelegate {
    
    var game = SetGame()

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var scoreCountLabel: UILabel!
    @IBOutlet private weak var deckView: DeckView!
    @IBOutlet private weak var deck:UIImageView!
    @IBOutlet private weak var circle:Circle!
    
    private lazy var animator = UIDynamicAnimator(referenceView: deckView)
    private lazy var cardBehavior = CardBehavior(in: animator)
    
    private var selectedCards: [CardView] {
        deckView.cardViews.filter { $0.state == .selected && !$0.isHidden }
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardBehavior.snapPoint = view.center
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
        let cardView = CardView(frame: CGRect(origin: CGPoint(x: view.bounds.maxX, y:       view.bounds.maxY), size: CGSize.zero))
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
            game.draw()
            for index in game.visibleCards.count - 3 ... game.visibleCards.count - 1 {
                addCardAt(index)
            }
        }
   }

    
    @objc func tapTheCard(_ gesture: UITapGestureRecognizer) {
           if gesture.state == .ended, let cardView = gesture.view as? CardView {
            let index = deckView.cardViews.firstIndex(of: cardView)!
            cardView.state = (cardView.state == .selected) ? .unselected : .selected
            game.chooseCard(at: index)
           }
       }
    
    @IBAction func showHint(_ sender:UIButton) {
        game.findSetIfPossible()
        game.hintedIndexes.forEach {
            deckView.cardViews[$0].state = .hinted
        }
        updateLabels()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        
    }
    
    // MARK: - Helper function
    
    private func updateLabels() {
        scoreLabel.text = "Scores: \(SetGame.scores)"
        scoreCountLabel?.text = "Matches: \(game.matchesFound)"
    }
    
    
    // MARK: - Protocol conformance
    
    func setWasFound() {
        updateLabels()
        selectedCards.forEach {
            deckView.bringSubviewToFront($0)
            cardBehavior.addItem($0)
        }
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
    
    
    private func enableUI(_ isUserInteractionEnabled: Bool) {
        deckView.cardViews.forEach { $0.isUserInteractionEnabled = isUserInteractionEnabled }
        view.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    private func shakeSelectedCards() {
        enableUI(false)
        selectedCards.forEach { cardView in
            ShakeAnimation.shake(view: cardView) {
                cardView.state = .unselected
                self.enableUI(true)
            }
        }
    }
    
}






