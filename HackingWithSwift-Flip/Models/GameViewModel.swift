//
//  GameViewModel.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation

@Observable
class GameViewModel {
    var board: Board
    
    init() {
        board = Board()
        
        board.rows[3][3] = .white
        board.rows[3][4] = .black
        board.rows[4][3] = .black
        board.rows[4][4] = .white
    }
}
