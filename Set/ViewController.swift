//
//  ViewController.swift
//  Set
//
//  Created by Russell Wunder on 22.05.19.
//  Copyright © 2019 Russell Snyder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = Set();
 
    let newGameExpressions = [
        "Every new game comes from some other game's end",
        "quit talking and begin doing",
        "start from now and make a brand new ending",
        "Be willing to be a beginner",
        "A journey begins with a single step"
    ]
    
    let activeStyle = [
        "backgroundColor": UIColor(white: 1, alpha: 0.25)
    ]

    let defaultStyle = [
        "backgroundColor": UIColor(white: 1, alpha: 1)
    ]

    let MAX_NUM_CARDS = 30
    
    var numCardsShowing: Int = 0
    var score = 0;

    // Int is the index in the cardButtons UI set
    var cardsChosen = [Int:Card]()
    
    func drawCards(_ drawCount: Int = 3) {
        if (numCardsShowing + 3 >= MAX_NUM_CARDS || numCardsShowing + 3 >= game.cards.count) {
            if (MAX_NUM_CARDS - numCardsShowing == 0) {
                sendInfoMessage("no more cards fit, \nfind a match!")
            } else {
                let maxCards = min(game.cards.count, MAX_NUM_CARDS)
                numCardsShowing += (maxCards - numCardsShowing);
            }
        } else {
            numCardsShowing += drawCount;
        }

        updateView()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var drawButton: UIButton!
    
    @IBOutlet weak var playingInformationLabel: UILabel!

    @IBOutlet weak var statsCardsShowing: UILabel!
    @IBOutlet weak var statsCardsRemaining: UILabel!
    @IBOutlet weak var statsSetsMatched: UILabel!
    @IBOutlet weak var statsScore: UILabel!
    
    func updateStats() {
        statsCardsShowing.text = "Cards Showing: \(numCardsShowing)"
        statsCardsRemaining.text = "Cards Remaining: \(max(game.cards.count - numCardsShowing, 0))"
        statsSetsMatched.text = "Sets Matched: \(game.matchedCards.count >= 3 ? game.matchedCards.count / 3 : 0)"
        statsScore.text = "Score: \(score)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }

    func setCardState(_ index: Int, _ active: Bool) {
        let style = active ? activeStyle : defaultStyle;
        cardButtons[index].backgroundColor = style["backgroundColor"]
    }
    
    func setAllCardsActiveState(_ active: Bool) {
        for i in 0..<cardButtons.count {
            setCardState(i, active)
        }
    }

    func setAllCardsHidden() {
        for card in cardButtons {
            card.isHidden = true
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        sendInfoMessage("")
        if (cardsChosen.count + 1 > 3) {
            cardsChosen.removeAll()
        }
        if let cardIndex = cardButtons.index(of: sender) {
            if (cardsChosen[cardIndex]	!= nil) {
                cardsChosen[cardIndex] = nil
            } else {
                cardsChosen[cardIndex] = game.cards[cardIndex]
                print(cardsChosen[cardIndex])

            }
            if (cardsChosen.count == 3) {
                let cards: [Card] = Array(cardsChosen.values)
                if(game.isASet(card1: cards[0], card2: cards[1], card3: cards[2])) {
                    // todo remove cards and draw three more if possible
                    game.moveMatchedCards(cards)
                    cardsChosen.removeAll()
                    numCardsShowing -= 3
                    drawCards()
                    sendInfoMessage(game.cards.count == 0 ? "You Won!!" : "it's a match!")
                    score += 5
                    
                } else {
                    sendInfoMessage("not a match :'(")
                    score -= 2

                }
            }
        } else {
            print("chosen card was not in card buttons")
        }
        updateView();
    }
    
    func setSymbolsInCards() {
        for i in 0..<cardButtons.count {
            if (i < game.cards.count) {
                let card = game.cards[i]
                let attributedText = NSAttributedString(string: card.createTitleString(), attributes: card.getNSAttributes())
                cardButtons[i].setAttributedTitle(attributedText, for: .normal)
            }
        }
    }
    
    func updateView() {
        setSymbolsInCards()
        setAllCardsActiveState(false)
        setAllCardsHidden()
        for (i, _) in cardsChosen {
            setCardState(i, true);
        }
        for i in 0..<numCardsShowing {
            cardButtons[i].isHidden = false
        }
        updateStats()
    }
    
    func setupGame() {
        cardsChosen.removeAll()
        numCardsShowing = 0
        game = Set()
        setAllCardsHidden()
        drawCards(12)
        updateView()
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        setupGame()
        sendInfoMessage(newGameExpressions.randomItem()!)
        updateView()
    }

    func sendInfoMessage(_ message: String) {
        playingInformationLabel.text = message
    }
    
    
    @IBAction func touchDraw(_ sender: UIButton) {
        drawCards()
    }    
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Card {
    func UIColorFromCard(alpha: Double = 1.0) -> UIColor {
        switch color {
        case .red:
            return UIColor(red: CGFloat(1),
                           green: CGFloat(0),
                           blue: CGFloat(0),
                           alpha: CGFloat(alpha))
        case .green:
            return UIColor(red: CGFloat(0),
                           green: CGFloat(1),
                           blue: CGFloat(0),
                           alpha: CGFloat(alpha))
        case .blue:
            return UIColor(red: CGFloat(0),
                           green: CGFloat(0),
                           blue: CGFloat(1),
                           alpha: CGFloat(alpha))
        default:
            return UIColor(red: CGFloat(1.0),
                           green: CGFloat(0.0),
                           blue: CGFloat(0.0),
                           alpha: CGFloat(alpha))
        }
    }
    
    func createTitleString() -> String {
        var symbol = "?";
        var titleString = ""
        
        switch shape {
        case .triangle:
            symbol = "▲"
        case .circle:
            symbol = "●"
        case .square:
            symbol = "■"
        }
        
        for _ in 1...count {
            titleString += symbol
        }
        
        return titleString
    }
    
    func getNSAttributes() -> [NSAttributedString.Key : Any] {
        var attributes = [NSAttributedString.Key : Any]();
        switch shade {
        case .solid:
            attributes[.foregroundColor] = UIColorFromCard()
            attributes[.strokeWidth] = -5
        case .striped:
            attributes[.foregroundColor] = UIColorFromCard(alpha: 0.25)
        case .open:
            attributes[.strokeWidth] = 5
            attributes[.strokeColor] = UIColorFromCard()
        }
        return attributes
    }
}

