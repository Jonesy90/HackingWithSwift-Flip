//
//  Board.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation

@Observable
class Board: NSObject {
    static let size = 8
    
    var rows: [[StoneColour]]
    var currentPlayer: Player
    
    override init() {
        //creating a new grid of empty stone.
        rows = Array(
            repeating: Array(
                repeating: StoneColour.empty, count: Board.size
            ), count: Board.size
        )
        
        //default to play going first.
        currentPlayer = Player.allPlayers[0]
    }
}
