//
//  Player.swift
//  HackingWithSwift-Flip
//
//  Created by Michael Jones on 14/03/2026.
//

import Foundation
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    static let allPlayers = [
        Player(stoneColour: .black),
        Player(stoneColour: .white)
    ]
    
    var stoneColour: StoneColour
    var playerId: Int //required for GameplayKit
    //a computed property to make selecting the 'opponent' easier.
    var opponent: Player {
        if stoneColour == .black {
            Player.allPlayers[1]
        } else {
            Player.allPlayers[0]
        }
    }
    
    init(stoneColour: StoneColour) {
        self.stoneColour = stoneColour
        self.playerId = stoneColour.rawValue
    }
}
