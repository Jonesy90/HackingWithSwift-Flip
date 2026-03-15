//
//  StoneView.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import SwiftUI

struct StoneView: View {
    var colour: StoneColour // the owner of the stone
    
    @State private var animationRotation = 0.0
    @State private var displayedColour: StoneColour? // is the colour we're showing right now.
    
    var body: some View {
        Group {
            switch displayedColour ?? colour {
            case .black:
                Image(.black)
            case .white:
                Image(.white)
            case .choice:
                Image(.thinking)
            case .empty:
                Color.clear
            }
        }
        .scaleEffect(0.8)
        .onAppear {
            displayedColour = colour
        }
        .rotation3DEffect(.degrees(animationRotation), axis: (x: 1, y: 0, z: 0), perspective: 0)
        .onChange(of: colour) { oldValue, newValue in
            if oldValue == .empty {
                displayedColour = newValue
            } else {
                withAnimation(.easeIn(duration: 0.2)) {
                    animationRotation = 90
                } completion: {
                    displayedColour = newValue
                    
                    withAnimation(.easeOut(duration: 0.2)) {
                        animationRotation = 0
                    }
                }
            }
        }
    }
}

#Preview {
    StoneView(colour: .white)
}
