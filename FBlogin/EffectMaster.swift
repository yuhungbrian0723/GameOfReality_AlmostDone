//
//  EffectMaster.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/20.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit
import SpriteKit

class EffectMaster: NSObject {
    let mcm = MapCoordinateMaster()
    
    func beatenEffect(targetSoldier: Player, damageValue: Int, scene: SKScene) {
        let damageNumber = SKLabelNode(text: String(damageValue))
        damageNumber.position = mcm.getPosition(fromTileName: targetSoldier.tileName!)
        damageNumber.fontColor = UIColor.red
        damageNumber.fontName = "Copperplate-Bold"
        damageNumber.zPosition = 2
        scene.addChild(damageNumber)
        let damageNumberAction = SKAction.move(by: CGVector.init(dx: 0, dy: 60), duration: 1)
        let labelFadeAway = SKAction.fadeOut(withDuration: 0.6)
        let actionWait = SKAction.wait(forDuration: 0.5)
        let actionSequence = SKAction.sequence([actionWait, labelFadeAway])
        let group = SKAction.group([damageNumberAction, actionSequence])
        
        let beatenActionRight = SKAction.move(by: CGVector.init(dx: 5, dy: 0), duration: 0.02)
        let beatenActionRightReverse = SKAction.reversed(beatenActionRight)
        let beatenActionLeft = SKAction.move(by: CGVector.init(dx: -5, dy: 0), duration: 0.02)
        let beatenActionLeftReverse = SKAction.reversed(beatenActionLeft)
        let beatenSequence = SKAction.sequence([beatenActionRight, beatenActionRightReverse(), beatenActionLeft, beatenActionLeftReverse()])
        let beatenResult = SKAction.repeat(beatenSequence, count: 6)
        targetSoldier.run(beatenResult)
        
        damageNumber.run(group, completion: {
            damageNumber.removeFromParent()
        })
    }
    
    func dieEffect(targetSoldier: Player) {
        let soldier = targetSoldier
        let beatenActionRight = SKAction.move(by: CGVector.init(dx: 5, dy: 0), duration: 0.02)
        let beatenActionRightReverse = SKAction.reversed(beatenActionRight)
        let beatenActionLeft = SKAction.move(by: CGVector.init(dx: -5, dy: 0), duration: 0.02)
        let beatenActionLeftReverse = SKAction.reversed(beatenActionLeft)
        let fadeAway = SKAction.fadeOut(withDuration: 0.5)
        let beatenSequence = SKAction.sequence([beatenActionRight, beatenActionRightReverse(), beatenActionLeft, beatenActionLeftReverse()])
        let beatenResult = SKAction.repeat(beatenSequence, count: 6)
        let finish = SKAction.sequence([beatenResult, fadeAway])
        soldier.run(finish) {
            soldier.removeFromParent()
        }
    }
    
    func deffenceEffect(selfPlayer: Player, view: SKScene) {
        let shield = SKShapeNode(rectOf: CGSize(width: 60, height: 60))
        let shieldIcon = SKTexture(imageNamed: "shieldIcon.png")
        shield.fillTexture = shieldIcon
        shield.fillColor = .white
        shield.strokeColor = .clear
        shield.zPosition = 5
        
        let apearing = SKAction.fadeIn(withDuration: 1)
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 0.3)
        moveUp.timingMode = .easeOut
        let actionSequene = SKAction.group([apearing, moveUp])
        
        shield.position = CGPoint(x: selfPlayer.position.x, y: selfPlayer.position.y - 20)
        view.addChild(shield)
        shield.run(actionSequene) { 
            shield.removeFromParent()
        }
    }
    
    
}
