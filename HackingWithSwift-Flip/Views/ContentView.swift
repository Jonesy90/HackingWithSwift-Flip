//
//  ContentView.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
