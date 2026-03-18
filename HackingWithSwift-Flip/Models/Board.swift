//
//  Board.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation
import GameplayKit

//used to track the state of play.
@Observable
class Board: NSObject, GKGameModel {
    static let size = 8
    
    var rows: [[StoneColour]]
    var currentPlayer: Player
    
    //An array of 8 directions that can be searched in. All can be represented using the Move object.
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
    
    /// Identifies if the requested move is valid.
    /// - Parameters:
    ///   - row: row selection.
    ///   - col: column selection
    /// - Returns: returns true or false if the move is valid.
    func canMoveIn(row: Int, col: Int) -> Bool {
        //checks if the row and column values are in the bounds of the board.
        guard isInBounds(row: row, col: col) else { return false }
        //checks if the rows cell on the board is not empty.
        guard rows[row][col] != .empty else { return false }
        
        //Loops over all the array of moves.
        for move in moves {
            var currentRow = row + move.row
            var currentCol = col + move.col
            var opponentCount = 0
            
            /*
             1. checks if the new row and column is within bounds of the board.
             AND
             2. checks if the selected cell contains an opponents stone.
            */
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
    
    
    /// Finds where potential moves and captures can take place. Once found, it would replace the valid cells with the stone colour of the currentPlayer.
    /// - Parameters:
    ///   - row: row selection
    ///   - col: column selection
    func makeMove(row: Int, col: Int) {
        rows[row][col] = currentPlayer.stoneColour // the selected square now belongs to the currentPlayer and their stoneColour.
        
        // loop over the moves array but searching from every direction.
        for move in moves {
            var mightCapture = [Move]() //tracks all the stones that might get captured.
            var currentRow = row + move.row
            var currentCol = col + move.col
            
            /*
             1. checks if the row and column are within the bounds of the board.
             2. checks if the row and column cell contains a opponent stone.
            */
            while isInBounds(row: currentRow, col: currentCol) && rows[currentRow][currentCol] == currentPlayer.opponent.stoneColour {
                //if both are true. it will add the row and column to 'mightCapture'.
                mightCapture.append(Move(row: currentRow, col: currentCol))
                currentRow += move.row
                currentCol += move.col
            }
            
            /*
             1. checks if the 'mightCapture' array is empty.
             2. checks if the row and column are within the bounds of the board.
             3. checks if the cell of the row and column contain the currentPlayers stone.
            */
            if mightCapture.isEmpty == false && isInBounds(row: currentRow, col: currentCol) && rows[currentRow][currentCol] == currentPlayer.stoneColour {
                //if all the above is true, it will change all stones to the currentPlayers stone.
                for capture in mightCapture {
                    rows[capture.row][capture.col] = currentPlayer.stoneColour
                }
            }
        }
        //updating the currentPlayer.
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
