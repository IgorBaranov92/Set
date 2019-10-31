import UIKit

class ConcentrationViewController: UIViewController, UISplitViewControllerDelegate {

    // MARK: - Public API

    lazy var cardButtons: [GameButton] = {
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
        return buttons
    }()
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
    var theme: (emoji:String,backgroundColor:UIColor,cardColor:UIColor)!
    var themeName = String()

    // MARK: - Private API

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
        print(cardButtons.count)
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
                cardButtons[cardIndex].isUserInteractionEnabled = false
                cardButtons[cardIndex].setTitle(String(emoji(for: game.cards[cardIndex])), for: .normal)
                UIView.transition(with: self.cardButtons[cardIndex],
                                  duration: Constants.durationForFlippingCard,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self.cardButtons[cardIndex].backgroundColor = .clear
                }){ completed in
                    if self.game.lastChosenIndex == nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
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
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
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
        flipCountLabel.text = traitCollection.verticalSizeClass == .compact ? "Flips\n\(game.flipCount)" : "Flips: \(game.flipCount)"
        scoreLabel.text = traitCollection.verticalSizeClass == .compact ? "Scores\n\(Concentration.scores)" : "Score: \(Concentration.scores)"
        newGameButton.setTitle(traitCollection.verticalSizeClass == .compact ? "New\ngame" : "New game", for: .normal)
    }

    private func updateConstraints() {
//        if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
//            var value: CGFloat = 150.0
//            if isPotraitOrientation {
//                value = 150.0
//            }
//            if isLandscapeOrientation {
//                value = 200.0
//            }
//            trailingConstraint.constant = value
//            leadingConstraint.constant = value
//        }

    }

    // MARK: - UISplitViewController delegate

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    

}


fileprivate struct Constants {
    static let durationForFlippingCard = 0.4

}

