//
//  StoneView.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import SwiftUI

struct StoneView: View {
    var colour: StoneColour
    
    var body: some View {
        switch colour {
        case .empty:
            Color.clear
        case .black:
            Image(.black)
        case .white:
            Image(.white)
        case .choice:
            Image(.thinking)
        }
    }
}

#Preview {
    StoneView(colour: .black)
}
