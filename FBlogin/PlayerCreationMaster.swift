//
//  PlayerCreationMaster.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/3.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerCreationMaster: NSObject {
    
    let mcm = MapCoordinateMaster(deviceWidth: 375)
    
    
    
    
    var players = [] as [SKSpriteNode]
    
    let wizardStand = SKTexture.init(imageNamed: "wizard_stand.png")
    let wizardWakingFrames = [SKTexture.init(imageNamed: "wizard_stand.png"),
                              SKTexture.init(imageNamed: "wizard_step1.png"),
                              SKTexture.init(imageNamed: "wizard_stand.png"),
                              SKTexture.init(imageNamed: "wizard_step2.png")]
    
    
//    func characterCreation(playerObjs: [Player], positionFromTeamFormation teamPosition: [String]) -> [SKSpriteNode]{
//        for i in 0..<playerObjs.count {
//            switch playerObjs[i].job {
//            case "warrior":
//                createWarrior(playerObj: playerObjs[i], position: teamPosition[i])
//            case "wizard":
//                createWizard(playerObj: playerObjs[i], position: teamPosition[i])
//            case "bard":
//                createBard(playerObj: playerObjs[i], position: teamPosition[i])
//            default:
//                print("Warning: player's job is invalid")
//            }
//        }
//        
//        return players
//        
//    }
    
    // player01wizard
//    func createWarrior(playerObj: Player, position: String) {
//        let character = SKSpriteNode(texture: tm.warriorStand, size: CGSize(width: mcm.tileLength, height: mcm.tileLength))
//        character.name = "player" + String(playerObj.characterId) + "war"
//        character.position = mcm.getPosition(fromTileName: position)
//        
//        players.append(character)
//    }
//    
//    func createWizard(playerObj: Player, position: String) {
//        let character = SKSpriteNode(texture: tm.wizardStand, size: CGSize(width: mcm.tileLength, height: mcm.tileLength))
//        character.name = "player" + String(playerObj.characterId) + "wiz"
//        character.position = mcm.getPosition(fromTileName: position)
//        
//        players.append(character)
//    }
//    
//    func createBard(playerObj: Player, position: String) {
//        let character = SKSpriteNode(texture: tm.wizardStand, size: CGSize(width: mcm.tileLength, height: mcm.tileLength))
//        character.name = "player" + String(playerObj.characterId) + "bar"
//        character.position = mcm.getPosition(fromTileName: position)
//        
//        players.append(character)
//    }
    
    
}
