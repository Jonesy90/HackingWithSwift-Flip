//
//  Board.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation
import GameplayKit

@Observable
class Board: NSObject, GKGameModel {
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
    
    var players: [any GKGameModelPlayer]? {
        Player.allPlayers
    }
    
    var activePlayer: (any GKGameModelPlayer)? {
        currentPlayer
    }
    
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
    
    //TODO: add description
    func makeMove(row: Int, col: Int) {
        rows[row][col] = currentPlayer.stoneColour // the selected square now belongs to the currentPlayer and their stoneColour.
        
        // loop over the moves array but searching from every direction.
        for move in moves {
            var mightCapture = [Move]()
            var currentRow = row + move.row
            var currentCol = col + move.col
            
            while isInBounds(row: currentRow, col: currentCol) && rows[currentRow][currentCol] == currentPlayer.opponent.stoneColour {
                mightCapture.append(Move(row: currentRow, col: currentCol))
                currentRow += move.row
                currentCol += move.col
            }
            
            if mightCapture.isEmpty == false && isInBounds(row: currentRow, col: currentCol) && rows[currentRow][currentCol] == currentPlayer.stoneColour {
                for capture in mightCapture {
                    rows[capture.row][capture.col] = currentPlayer.stoneColour
                }
            }
        }
        
        currentPlayer = currentPlayer.opponent
    }
    
    //TODO: add description
    func gameModelUpdates(for player: any GKGameModelPlayer) -> [GKGameModelUpdate]? {
        var moves = [Move]()
        
        for row in 0..<Board.size {
            for col in 0..<Board.size {
                if canMoveIn(row: row, col: col) {
                    moves.append(Move(row: row, col: col))
                }
            }
        }
        
        return moves.isEmpty ? nil : moves
    }
    
    //TODO: add description
    func setGameModel(_ gameModel: any GKGameModel) {
        guard let board = gameModel as? Board else { return }
        
        currentPlayer = board.currentPlayer
        rows = board.rows
    }
    
    //TODO: add description
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        
        copy.setGameModel(self)
        return copy
    }
    
    //TODO: add description
    func apply(_ gameModelUpdate: any GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else { return }
        
        makeMove(row: move.row, col: move.col)
    }
    
    //TODO: add description
    func getScores() -> (black: Int, white: Int) {
        var black = 0
        var white = 0
        
        for row in rows {
            for stone in row {
                if stone == .black {
                    black += 1
                } else if stone == .white {
                    white += 1
                }
            }
        }
        
        return (black, white)
    }
    
    //TOOD: add description
    func score(for player: any GKGameModelPlayer) -> Int {
        guard let playerObject = player as? Player else { return 0 }
        
        let scores = getScores()
        
        var score = if playerObject.stoneColour == .black {
            scores.black - scores.white
        } else {
            scores.white - scores.black
        }
        
        //these are the (row, col) of the four corners of the board.
        let corners = [
            (0, 0),
            (0, 7),
            (7, 0),
            (7, 7)
        ]
        
        for (row, col) in corners {
            if rows[row][col] == playerObject.stoneColour {
                score += 10
            } else if rows[row][col] == playerObject.opponent.stoneColour {
                score -= 10
            }
        }
        
        return score
    }
}
