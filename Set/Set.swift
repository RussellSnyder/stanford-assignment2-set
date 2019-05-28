//
//  Set.swift
//  Set
//
//  Created by Russell Wunder on 22.05.19.
//  Copyright © 2019 Russell Snyder. All rights reserved.
//

import Foundation

enum Color: CaseIterable {
    case red
    case green
    case blue
}

enum Shade: CaseIterable {
    case solid
    case striped
    case open
}

enum Shape: CaseIterable {
    case triangle
    case circle
    case square
}

struct Set {
    var cards = [Card]()
    var matchedCards = [Card]()
    
    init() {
        generateCards()
    }

    let MAX_COUNT = 3;
    
    func getFeaturesInCommon(card1: Card, card2: Card) -> [String] {
        var featuresInCommon = [String]();
        if card1.color == card2.color {
            featuresInCommon.append("color")
        }
        if card1.shade == card2.shade {
            featuresInCommon.append("shade")
        }
        if card1.shape == card2.shape {
            featuresInCommon.append("shape")
        }
        if card1.count == card2.count {
            featuresInCommon.append("count")
        }
        return featuresInCommon
    }

    
    func isASet(card1: Card, card2: Card, card3: Card) -> Bool {
        var conditionsMet = [String]();

        let featureInCommon12: [String] = getFeaturesInCommon(card1: card1, card2: card2)
        let featureInCommon23: [String] = getFeaturesInCommon(card1: card2, card2: card3)
        let featureInCommon31: [String] = getFeaturesInCommon(card1: card3, card2: card1)
        
        let featuresInCommon = featureInCommon12 + featureInCommon23 + featureInCommon31
        
        let featureInCommonCounts = featuresInCommon.reduce(into: [:]) { counts, letter in
            counts[letter, default: 0] += 1
        }

        
        //   A set consists of three cards satisfying all of these conditions:
        //   meetsConditionCount     They all have the same number or have three different numbers.
        //   meetsConditionShape     They all have the same shape or have three different shapes.
        //   meetsConditionShade     They all have the same shading or have three different shadings.
        //   meetsConditionColor     They all have the same color or have three different colors.
        
        featureInCommonCounts.forEach {
            if $1 == 3 {
                conditionsMet.append($0)
            }
        }

        if (featureInCommonCounts["color"] == nil) {
            conditionsMet.append("color")
        }
        if (featureInCommonCounts["shape"] == nil) {
            conditionsMet.append("shape")
        }
        if (featureInCommonCounts["shade"] == nil) {
            conditionsMet.append("shade")
        }
        if (featureInCommonCounts["count"] == nil) {
            conditionsMet.append("count")
        }

        
        return conditionsMet.count == 4

    }

    mutating func moveMatchedCards(_ cardSet: [Card]) {
        matchedCards.append(contentsOf: cardSet)
        for card in cardSet {
            if let index = cards.index(of: card) {
                cards.remove(at: index)
            } else {
                print("moveMatchedCards: can't move card that isn't in cards")
            }
        }
        print(cards.count)
    }
    
    mutating func generateCards() {
        cards = [Card]()
        for color in Color.allCases {
            for shade in Shade.allCases {
                for shape in Shape.allCases {
                    for count in 1...MAX_COUNT {
                        cards.append(Card(color, shade, shape, count))
                    }
                }
            }
        }
        cards.shuffle()
    }
}
