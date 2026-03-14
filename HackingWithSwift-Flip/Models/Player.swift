//
//  Player.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation

class Player: NSObject {
    static let allPlayers = [
        Player(stoneColour: .black),
        Player(stoneColour: .white)
    ]
    
    var stoneColour: StoneColour
    var playerId: Int //required for GameplayKit
    var opponent: Player {
        if stoneColour == .black {
            Player.allPlayers[0]
        } else {
            Player.allPlayers[1]
        }
    }
    
    init(stoneColour: StoneColour) {
        self.stoneColour = stoneColour
        self.playerId = stoneColour.rawValue
    }
}
