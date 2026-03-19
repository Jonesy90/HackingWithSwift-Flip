//
//  ContentView.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import SwiftUI

struct ContentView: View {
    //A property to create and store the view model.
    @State private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
            
            Image(.board)
                .overlay{
                    BoardView(viewModel: viewModel)
                }
        }
        .alert("Game Over", isPresented: $viewModel.isGameOver) {
            Button("Play Again?", role: .confirm) {
                viewModel = GameViewModel()
            }
        } message: {
            let score = viewModel.board.getScores()
            Text((score.black > score.white ? "Computer" : "Player") + " Wins!")
        }
    }
}

#Preview {
    ContentView()
}
