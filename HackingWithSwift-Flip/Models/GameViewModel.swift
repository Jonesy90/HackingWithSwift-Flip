//
//  GameViewModel.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation
import GameplayKit

@Observable
class GameViewModel {
    var board: Board
    
    var strategist = GKMinmaxStrategist()
    var isAIThinking: Bool = false
    var isGameOver = false
    
    var hasValidMoves: Bool {
        for row in 0..<Board.size {
            for col in 0..<Board.size {
                if board.canMoveIn(row: row, col: col) {
                    return true
                }
            }
        }
        
        return false
    }
    
    init() {
        board = Board()
        
        board.rows[3][3] = .white
        board.rows[3][4] = .black
        board.rows[4][3] = .black
        board.rows[4][4] = .white
        
        strategist.maxLookAheadDepth = 3
        strategist.gameModel = board
    }
    
    //TODO: add description
    func makeMove(row: Int, col: Int) {
        board.makeMove(row: row, col: col)
        
        updateGameState()
        
        if board.currentPlayer.stoneColour == .white && isGameOver == false {
            makeAIMove()
        }
    }
    
    //TODO: add description
    func makeAIMove() {
        isAIThinking = true
        
        Task {
            try await Task.sleep(for: .seconds(1))
            
            let move = strategist.bestMove(for: board.currentPlayer) as? Move
            
            guard let move else {
                isAIThinking = false
                updateGameState()
                return
            }
            
            board.rows[move.row][move.col] = .choice
            
            try await Task.sleep(for: .seconds(1))
            
            board.rows[move.row][move.col] = .empty
            board.makeMove(row: move.row, col: move.col)
            isAIThinking = false
            
            updateGameState()
            
            if board.currentPlayer.stoneColour == .white && isGameOver == false {
                makeAIMove()
            }
        }
    }
    
    //TODO: add description
    func updateGameState() {
        if hasValidMoves { return }
        
        board.currentPlayer = board.currentPlayer.opponent
        
        if hasValidMoves { return }
        
        isGameOver = true
    }
}
