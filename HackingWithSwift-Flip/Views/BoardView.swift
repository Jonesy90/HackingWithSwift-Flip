//
//  BoardView.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import SwiftUI

struct BoardView: View {
    var viewModel: GameViewModel
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<Board.size, id: \.self) { row in
                GridRow {
                    ForEach(0..<Board.size, id: \.self) { col in
                        ZStack {
                            StoneView(colour: viewModel.board.rows[row][col])
                            
                            if viewModel.board.canMoveIn(row: row, col: col) && viewModel.isGameOver == false && viewModel.isGameOver == false {
                                Button {
                                    viewModel.makeMove(row: row, col: col)
                                } label: {
                                    if viewModel.board.currentPlayer.stoneColour == .white {
                                        Color.white.opacity(0.2)
                                    } else {
                                        Color.black.opacity(0.3)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(width: 60, height: 60)
                    }
                }
            }
        }
    }
}

#Preview {
    BoardView(viewModel: GameViewModel())
}
