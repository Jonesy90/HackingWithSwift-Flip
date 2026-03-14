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
