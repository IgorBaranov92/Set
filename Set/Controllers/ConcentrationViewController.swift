import UIKit

class ConcentrationViewController: UIViewController {
    
    private var theme: (emoji:String,backgroundColor:UIColor,cardColor:UIColor)!
    private var themeName = String()
    private lazy var game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
    private var currentEmoji = String()
    private var emoji = [ConcentrationCard:Character]()
    private var lastIndex: Int?

    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet private weak var themeNameLabel:UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet private weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewGame()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateLabelsAndButton()
        updateConstraints()
    }

    // MARK: - IBAction


    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            if !game.cards[cardIndex].isMatched && cardButtons[cardIndex].currentTitle == "" {
                if game.lastChosenIndex == nil { cardButtons[cardIndex].isUserInteractionEnabled = false
                    lastIndex = cardIndex
                } else {
                    enableUI(false)
                }
                game.chooseCard(at: cardIndex)
                cardButtons[cardIndex].setTitle(String(emoji(for: game.cards[cardIndex])),                                  for: .normal)
                UIView.transition(with: cardButtons[cardIndex],
                                  duration: Constants.durationForFlippingCard,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    self.cardButtons[cardIndex].backgroundColor = .clear
                }){ completed in
                    if self.lastIndex != nil,self.lastIndex! != cardIndex {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeInterval) {}
                        [self.lastIndex!,cardIndex].forEach { index in
                            if !self.game.cardsAreMatched {
                                UIView.transition(with: self.cardButtons[index],
                                  duration: Constants.durationForFlippingCard,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                self.cardButtons[index].setTitle("", for: .normal)
                                self.cardButtons[index].backgroundColor = self.theme.cardColor
                                }) { completed in self.enableUI(true) }
                            } else {
                                if self.game.gameCompleted {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeInterval) {
                                        self.createNewGame()
                                        self.enableUI(true)
                                    }
                                } else {
                                    self.cardButtons[index].setTitle("", for: .normal)
                                    self.enableUI(true)
                                }
                            }
                        }
                    }
                }
                updateLabelsAndButton()
            }
        }
    }

    // MARK: - IBAction


    @IBAction func newGame(_ sender: UIButton) {
        createNewGame()
    }

    private func createNewGame() {
        game = Concentration(numberOfPairsOfCards: cardButtons.count/2)
        let randomIndex = Int.random(in: 0..<themes.count)
        theme = Array(themes.values)[randomIndex]
        currentEmoji = theme.emoji
        cardButtons.forEach { $0.backgroundColor = theme.cardColor;$0.setTitle("", for: .normal);$0.isUserInteractionEnabled = true }
        view.backgroundColor = theme.backgroundColor
        flipCountLabel.text = "Flips" + String(game.flipCount)
        scoreLabel.text = "Scores" + String(Concentration.scores)
        themeNameLabel.text = Array(themes.keys)[randomIndex]
        themeNameLabel.textColor = theme.cardColor
        scoreLabel.textColor = theme.cardColor
        flipCountLabel.textColor = theme.cardColor
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
    }
    
    
    private func updateConstraints() {
        print(newGameButton.frame)
        if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
            if isPotraitOrientation {
                stackView.axis = .vertical
                for subView in stackView.subviews {
                    if let subStackView = subView as? UIStackView {
                        subStackView.axis = .horizontal
                    }
                }
                leadingConstraint.constant = Constants.leadingConstraintInPortrait
                trailingConstraint.constant = leadingConstraint.constant
            }
            if isLandscapeOrientation {
                leadingConstraint.constant = 160.0
                trailingConstraint.constant = leadingConstraint.constant
                stackView.axis = .horizontal
                for subView in stackView.subviews {
                    if let subStackView = subView as? UIStackView {
                        subStackView.axis = .vertical
                    }
                }
            }
        }

    }

    private func enableUI(_ isUserInteractionEnabled:Bool) {
        cardButtons.forEach { $0.isUserInteractionEnabled = isUserInteractionEnabled }
    }

    
    private let themes : [String:(emoji:String,cardColor:UIColor,backgroundColor:UIColor)] = [
        "Halloween":
         ("🤡😈👿👹👺💀☠️👻👽👾🤖🦇🦉🕷🕸🥀🍫🍬🍭🎃🔮🎭🕯🗡⛓⚰️⚱️",#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        "Sport" : ("⚽⚾🏀🏐🏈🏉⛹🤾🥎🏏🏑🏒🥅🥍🏓🎾🏸🥊🥋🤺🤼🏃🏇🏋🏹🤸🤹🛹🥏🎳🏊🏄🤽🎿⛸⛷🏂🛷🥌🏌⛳🧭⛺🎣🧗",#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)) ,
        "Transport" :
            ("✈️⛵🚤🚣🚀🚁🚂🚊🚅🚃🚎🚌🚍🚙🚘🚗🚕🚖🚛🚚🚓🚔🚒🚑🚐🚲🚡🚟🚠🚜", #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        "Animal": ("🐶🐺🐱🐭🐹🐰🐸🐯🐨🐻🐷🐮🐗🐵🐒🐴🐑🐘🐼🐧🐦🐤🐥🐣🐔🐍🐢🐛🐝🐜🐞🐌🐙🐚🐠🐟🐬🐳🐋🐄🐏🐀🐃🐅🐇🐉🐎🐐🐓🐕🐖🐁🐂🐲🐡🐊🐫🐪🐆🐈🐩",#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.8306297664, green: 1, blue: 0.7910112419, alpha: 1)) ,
        "Food":("☕🍵🍶🍼🍺🍻🍸🍹🍷🍴🍕🍔🍟🍗🍖🍝🍛🍤🍱🍣🍥🍙🍘🍚🍜🍲🍢🍡🍳🍞🍩🍮🍦🍨🍧🎂🍰🍪🍫🍬🍭🍯",#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1),#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) ),
        "Clothes"
            : ("🎩👑👒👟👞👡👠👢👕👔👚👗🎽👖👘👙💼👜👝👛👓🎀🌂💄",#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.7650054947, blue: 0.8981300767, alpha: 1)),
        "Objects"
            : ("🔧⚒⛏🔩⚙🧲⚖💎💰📡⏰☎🔑🗝🧪🧬💊🧸📦✏🔗📐🔒📍✂",#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1))
    ]
    
    private lazy var cardButtons: [UIButton] = {
        var buttons = [UIButton]()
        for subview in view.subviews {
            if let stackView = subview as? UIStackView {
                for stackViewSubview in stackView.subviews {
                    if let subStackView = stackViewSubview as? UIStackView {
                        for button in subStackView.subviews {
                            if let gameButton = button as? UIButton {
                                buttons.append(gameButton)
                            }
                        }
                    }
                }
            }
        }
        return buttons.filter { $0.isHidden == false }
    }()
}


fileprivate struct Constants {
    static let durationForFlippingCard = 0.4
    static let leadingConstraintInPortrait:CGFloat = 60.0
    static let timeInterval =  0.15
}

