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
    
    @State private var selectedLevel = 3
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
            
            if viewModel.isNewGame {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.gray.opacity(0.9))
                    
                    VStack {
                        Text("New Game")
                            .font(.custom("Gujarati MT Bold", size: 30))
                            .foregroundStyle(.black)
                        
                        NavigationStack {
                            Form {
                                Picker("Level", selection: $selectedLevel) {
                                    Text("Easy").tag(1)
                                    Text("Medium").tag(3)
                                    Text("Hard").tag(5)
                                    Text("Impossible").tag(10)
                                }
                                .labelsHidden()
                                .pickerStyle(.segmented)
                            }
                        }
                        .foregroundStyle(.black)
                        
                        Button("Start Game") {
                            viewModel.isNewGame = false
                        }
                    }
                }
                .containerRelativeFrame([.horizontal, .vertical]) { size, axis in
                    if axis == .horizontal {
                        size * 0.5
                    } else {
                        size * 0.5
                    }
                }
            } else {
                Image(.board)
                    .overlay{
                        BoardView(viewModel: viewModel)
                    }
            }
        }
        .disabled(viewModel.isAIThinking)
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
