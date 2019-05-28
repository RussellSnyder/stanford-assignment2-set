//
//  Card.swift
//  Set
//
//  Created by Russell Wunder on 22.05.19.
//  Copyright © 2019 Russell Snyder. All rights reserved.
//

import Foundation

struct Card {
    let color: Color
    let shade: Shade
    let shape: Shape
    let count: Int
    
    init(_ color:Color, _ shade:Shade, _ shape:Shape, _ count:Int) {
        self.color = color
        self.shade = shade
        self.shape = shape
        self.count = count
    }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.color == rhs.color &&
            lhs.shade == rhs.shade &&
            lhs.shape == rhs.shape &&
            lhs.count == rhs.count
    }

}
