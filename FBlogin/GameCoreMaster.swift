//
//  GameCoreMaster.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/28.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit

class GameCoreMaster: NSObject {
    
    var playersOrderId = Array<Int>()
    var currentSoldierActionId = 0
    var actionPoint = 5
    
    func playerSequenceOrder(players: [Player]) {
        var playersOrderBySpeed = players
        playersOrderBySpeed.sort(by: {$0.0.shareSpeedToActionBar() > $0.1.shareSpeedToActionBar()})
        
        for player in playersOrderBySpeed {
            playersOrderId.append(player.battleId)
        }
    }
    
    
    /**
     Change the very soldier who should act according to playersOrderId over turn change
    */
    func soldierTurnChange() {
        
        let firstObj = playersOrderId.remove(at: 0)
        playersOrderId.append(firstObj)
        
        currentSoldierActionId = playersOrderId[0]
        
    }
    
    
    
    func isGameEnd(players: [Player]) -> Bool{
        var teamOneAlive = Array<Bool>()
        var teamTwoAlive = Array<Bool>()
        for player in players {
            if player.teamSide == 1 {
                teamOneAlive.append(player.alive)
            } else {
                teamTwoAlive.append(player.alive)
            }
        }
        
        for alive in teamOneAlive {
            if alive == true {
                break
            } else {
                return true
            }
        }
        
        for alive in teamTwoAlive {
            if alive == true {
                break
            } else {
                return true
            }
        }
        
        return false
        
    }

}
