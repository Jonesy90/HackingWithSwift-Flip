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
    
    let moves = [
        Move(row: -1, col: -1),
        Move(row: -1, col: 0),
        Move(row: -1, col: 1),
        Move(row: 0, col: -1),
        Move(row: 0, col: 1),
        Move(row: 1, col: -1),
        Move(row: 1, col: 0),
        Move(row: 1, col: 1)
    ]
    
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
    
    /// A helper method to check if the selection the player has made is in bounds.
    /// - Parameters:
    ///   - row: row selection made by user.
    ///   - col: col selection made by user
    /// - Returns: returns true or false if the selection made is valid.
    func isInBounds(row: Int, col: Int) -> Bool {
        row >= 0 && col >= 0 && row < Board.size && col < Board.size
    }
    
    func canMoveIn(row: Int, col: Int) -> Bool {
        guard isInBounds(row: row, col: col) else { return false }
        guard rows[row][col] == .empty else { return false }
        
        for move in moves {
            var currentRow = row + move.row
            var currentCol = col + move.col
            var opponentCount = 0
            
            //TODO: add description
            while isInBounds(row: currentRow, col: currentCol) && rows[currentRow][currentCol] == currentPlayer.opponent.stoneColour {
                currentRow += move.row
                currentCol += move.col
                opponentCount += 1
            }
            
            //TODO: add description
            if opponentCount > 0 && isInBounds(row: currentRow, col: currentCol) && rows[currentRow][currentCol] == currentPlayer.stoneColour {
                return true
            }
        }
        
        return false
    }
}
