import UIKit

class ConcentrationViewController: UIViewController, UISplitViewControllerDelegate {

    // MARK: - Public API

    var theme: (emoji:String,backgroundColor:UIColor,cardColor:UIColor)!
    var themeName = String()
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    // MARK: - Private API

    private lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
    private lazy var cardButtons: [GameButton] = {
        var buttons = [GameButton]()
        for subview in view.subviews {
            if let stackView = subview as? UIStackView {
                for stackViewSubview in stackView.subviews {
                    if let subStackView = stackViewSubview as? UIStackView {
                        for button in subStackView.subviews {
                            if let gameButton = button as? GameButton {
                                buttons.append(gameButton)
                            }
                        }
                    }
                }
            }
        }
        return buttons.filter { $0.isHidden == false }
    }()
    
    private var currentEmoji = String()
    private var emoji = [ConcentrationCard:Character]()
    private var lastChosenIndexOfCard: Int?
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - ViewController lifecycle

    override func awakeFromNib() {
        splitViewController?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGame()
        navigationItem.title = themeName
        print("cardButtonsCount = \(cardButtons.count)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLabelsAndButton()
        updateConstraints()
    }

    // MARK: - IBActions


    @IBAction func touchCard(_ sender: GameButton) {
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            if !game.cards[cardIndex].isMatched && cardButtons[cardIndex].currentTitle == "" {
                game.chooseCard(at: cardIndex)
                if lastChosenIndexOfCard == nil { lastChosenIndexOfCard = cardIndex }
                cardButtons[cardIndex].setTitle(String(emoji(for: game.cards[cardIndex])), for: .normal)
                UIView.transition(with: self.cardButtons[cardIndex],
                                  duration: Constants.durationForFlippingCard,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self.cardButtons[cardIndex].backgroundColor = .clear
                }){ completed in
                    if self.game.lastChosenIndex == nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeInterval) {
                            if self.lastChosenIndexOfCard != nil {
                                [self.lastChosenIndexOfCard!,cardIndex].forEach { index in
                                    self.cardButtons[index].setTitle("", for: .normal)
                                    if !self.game.cardsAreMatched {
                                        UIView.transition(with: self.cardButtons[index],
                                          duration: Constants.durationForFlippingCard,
                                          options: .transitionFlipFromLeft,
                                          animations: {
                                        self.cardButtons[index].backgroundColor = self.theme.cardColor
                                        }) { completed in }
                                    } else {
                                        if self.game.gameCompleted {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeInterval) {
                                                self.createNewGame()
                                            }
                                        }
                                    }
                                }
                                self.lastChosenIndexOfCard = nil
                            }

                        }
                    }
                }
                updateLabelsAndButton()
            }

        }
    }

    // MARK: - IBActions


    @IBAction func newGame(_ sender: UIButton) {
        createNewGame()
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true)
    }

    private func createNewGame() {
        game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
        currentEmoji = theme.emoji
        cardButtons.forEach { $0.backgroundColor = theme.cardColor;$0.setTitle("", for: .normal);$0.isUserInteractionEnabled = true }
        view.backgroundColor = theme.backgroundColor
        flipCountLabel.text = "Flips" + String(game.flipCount)
        scoreLabel.text = "Scores" + String(Concentration.scores)
        scoreLabel.textColor = theme.cardColor
        flipCountLabel.textColor = theme.cardColor
        backButton.setTitleColor(theme.cardColor, for: .normal)
        newGameButton.setTitleColor(theme.cardColor, for: .normal)
    }

    private func emoji(for card:ConcentrationCard) -> Character {
        if emoji[card] == nil {
            let randomIndex = currentEmoji.index(currentEmoji.startIndex,
                                                 offsetBy: Int.random(in: 0..<currentEmoji.count))
            emoji[card] = currentEmoji.remove(at: randomIndex)
        }
        return emoji[card] ?? "?"
    }

    private func updateLabelsAndButton() {
        flipCountLabel.text = isLandscapeOrientation ? "Flips\n\(game.flipCount)" : "Flips: \(game.flipCount)"
        scoreLabel.text = isLandscapeOrientation ? "Scores\n\(Concentration.scores)" : "Score: \(Concentration.scores)"
        newGameButton.setTitle(isLandscapeOrientation ? "New\ngame" : "New game", for: .normal)
        print("device orientation is landscape? \(isLandscapeOrientation)")
    }
    
    
    private func updateConstraints() {
        if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
            print("it's ipad")
            if isPotraitOrientation {
                leadingConstraint.constant = Constants.leadingConstraintInPortrait
                trailingConstraint.constant = leadingConstraint.constant
            }
            if isLandscapeOrientation {
                leadingConstraint.constant = 190.0
                trailingConstraint.constant = leadingConstraint.constant
            }
        }

    }

    // MARK: - UISplitViewController delegate

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    

}


fileprivate struct Constants {
    static let durationForFlippingCard = 0.4
    static let leadingConstraintInPortrait:CGFloat = 20.0
    static let timeInterval =  0.15
}

