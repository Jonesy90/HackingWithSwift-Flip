//
//  Move.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var row: Int
    var col: Int
    var value = 0
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
