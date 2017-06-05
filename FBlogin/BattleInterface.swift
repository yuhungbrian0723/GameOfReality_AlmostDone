//
//  BattleInterface.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/28.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit
import SpriteKit

class BattleInterface: NSObject {
    
    let mainContainer = SKNode()
    var idLabel = SKLabelNode()
    var healthPointLabel = SKLabelNode()
    
    let orderIconContainer = SKNode()
    var orderIconGroup = SKShapeNode()
    
    
    let skillIconContainer = SKNode()
    var skillIconGroup = SKShapeNode()
    
    let testLabel = SKLabelNode(text: "Action Order")
    
    let warriorIcon = SKTexture(imageNamed: "warrior_icon")
    let wizardIcon = SKTexture(imageNamed: "wizard_icon")
    let bardIcon = SKTexture(imageNamed: "bard_icon")
    
    var gemArray = Array<SKSpriteNode>()
    
    override init() {
        orderIconContainer.addChild(testLabel)
    }
    
    // MARK: - actionOrderBar
    func createActionOrderBar(view:SKScene, players:[Player], solderOrderId:[Int]) {
        
        orderIconGroup = SKShapeNode(rect: CGRect.init(x: 0, y: 0, width: 250, height: 50), cornerRadius: 10)
        orderIconGroup.strokeColor = .brown
        testLabel.fontColor = .red
        testLabel.horizontalAlignmentMode = .left
        testLabel.position = CGPoint(x: 5, y: 30)
        testLabel.fontSize = 18.0
        
        var isFirst = true
        var i = 0
        for playerId in solderOrderId {
            if let playerIndex = players.index(where: {$0.battleId == playerId}) {
                
                if isFirst {
                    let soldierIcon = SKShapeNode(rectOf: CGSize.init(width: 30, height: 30), cornerRadius: 15)
                    soldierIcon.setScale(1.3)
                    soldierIcon.name = String(playerId)
                    soldierIcon.fillColor = .white
                    soldierIcon.position = CGPoint(x: (20 + (i * 25)), y: (20))
                    
                    if players[playerIndex].teamSide == 1 {
                        soldierIcon.strokeColor = .blue
                    } else if players[playerIndex].teamSide == 2 {
                        soldierIcon.strokeColor = .red
                    }
                    
                    switch players[playerIndex].job {
                    case "warrior":
                        soldierIcon.fillTexture = warriorIcon
                    case "wizard":
                        soldierIcon.fillTexture = wizardIcon
                    case "bard":
                        soldierIcon.fillTexture = bardIcon
                    default:
                        break
                    }
                    
                    orderIconGroup.addChild(soldierIcon)
                    i += 1
                    isFirst = false
                } else {
                    let soldierIcon = SKShapeNode(rectOf: CGSize.init(width: 30, height: 30), cornerRadius: 15)
                    soldierIcon.name = String(playerId)
                    soldierIcon.fillColor = .white
                    soldierIcon.position = CGPoint(x: (30 + (i * 25)), y: (15))
                    
                    if players[playerIndex].teamSide == 1 {
                        soldierIcon.strokeColor = .blue
                    } else if players[playerIndex].teamSide == 2 {
                        soldierIcon.strokeColor = .red
                    }
                    
                    switch players[playerIndex].job {
                    case "warrior":
                        soldierIcon.fillTexture = warriorIcon
                    case "wizard":
                        soldierIcon.fillTexture = wizardIcon
                    case "bard":
                        soldierIcon.fillTexture = bardIcon
                    default:
                        break
                    }
                    
                    orderIconGroup.addChild(soldierIcon)
                    i += 1
                }
                
                
                
            }
        }
        
        // soliderOrderBar postion setting
        orderIconContainer.position = CGPoint(x: 10, y: 610)
        orderIconContainer.addChild(orderIconGroup)
        view.addChild(orderIconContainer)
        
        
    }
    
    // MARK: updateActionOrderBar
    func updateActionOrderBar(playerObjs: [Player], solderOrderId: inout [Int]) {
        
        checkSoldierAlive(playerObjs: playerObjs, solderOrderId: &solderOrderId)
        
        var times = 0
        
        if orderIconGroup.children.count == 1 {
            if let icon = orderIconGroup.children.first as? SKShapeNode {
                icon.position = CGPoint(x: 20, y: 20)
                icon.setScale(1.3)
            }
        } else {
            for icon in orderIconGroup.children {
                if times == 0 {
                    icon.position = CGPoint(x: (30 + ((orderIconGroup.children.count - 1) * 25)), y: 15)
                    icon.setScale(1)
                    times += 1
                } else if times == 1{
                    icon.position = CGPoint(x: 20, y: 20)
                    icon.setScale(1.3)
                    times += 1
                } else {
                    icon.position = CGPoint(x: (30 + ((times - 1) * 25)), y: Int(icon.position.y))
                    times += 1
                }
            }
        }
        
        let firstObj = orderIconGroup.children.first
        orderIconGroup.children.first?.removeFromParent()
        orderIconGroup.addChild(firstObj!)
    }
    // MARK: -
    
    func checkSoldierAlive(playerObjs: [Player], solderOrderId: inout [Int]) {
        
        for player in playerObjs {
            if player.alive == false {
                if let i = solderOrderId.index(where: {$0 == player.battleId}) {
                    solderOrderId.remove(at: i)
                    
                }
                
                if let i = orderIconGroup.children.index(where: {$0.name == String(player.battleId)}) {
                    orderIconGroup.children[i].removeFromParent()
                }
            }
        }
    }
    
    // MARK: - createMainContainer
    func createMainContainer(view: SKScene, deviceWidth: Int, deviceHeight: Int) {
        let mainContainerBase = SKShapeNode(rect: CGRect.init(x: 0, y: 0, width: deviceWidth, height: 100), cornerRadius: 0)
//        mainContainerBase.strokeColor = .init(red: 28 / 255, green: 40 / 255, blue: 27 / 255, alpha: 1)
//        mainContainerBase.lineWidth = 5
//        mainContainerBase.fillColor = .init(red: 39 / 255, green: 61 / 255, blue: 55 / 255, alpha: 1)
        mainContainerBase.fillColor = .white
        mainContainerBase.fillTexture = SKTexture(imageNamed: "info")
        
        
        idLabel.text = "ID:"
        idLabel.fontColor = .black
        idLabel.fontName = "Cochin-Bold"
        idLabel.horizontalAlignmentMode = .left
        idLabel.position = CGPoint(x: 20, y: 60)
        
        healthPointLabel.text = "HP:"
        healthPointLabel.fontColor = .black
        healthPointLabel.fontName = "Cochin-Bold"
        healthPointLabel.horizontalAlignmentMode = .left
        healthPointLabel.position = CGPoint(x: 20, y: 20)
        
        mainContainerBase.addChild(idLabel)
        mainContainerBase.addChild(healthPointLabel)
        
        mainContainer.addChild(mainContainerBase)
        mainContainer.position = CGPoint(x: 0, y: 0)
        view.addChild(mainContainer)
    }
    
    // MARK: - createActionPoint
    func createActionPoint(view:SKScene, actionPoint: Int){
        let num = 20
        
        for i in 1...10{
            let gem = SKSpriteNode(imageNamed:"grayGem.png")
            gem.position = CGPoint(x:num*i,y:115)
            gem.size.height = 20
            gem.size.width = 20
            gem.name = "gem"+(String(i))
            view.addChild(gem)
            gemArray.append(gem)
            
        }
        for i in 0...(actionPoint - 1){
            gemArray[i].texture = SKTexture(imageNamed: "greenGem.png")
            
        }
        
        print(gemArray.count)
        
    }
    
    // MARK: updateActionPoint
    func updateActionPoint(actionPoint: Int){
        
        if actionPoint == 0{
            gemArray[0].texture = SKTexture(imageNamed: "grayGem")
        }else if (actionPoint > 0){
            for i in 0...(actionPoint - 1){
                gemArray[i].texture = SKTexture(imageNamed: "greenGem")
//                print("這是一個：\(gemArray[i].texture)")
            }
            for i in actionPoint..<10 {
                gemArray[i].texture = SKTexture(imageNamed: "grayGem")
//                print("這是一個：\(gemArray[i].texture)")
            }
        }
    }
    // MARK: -
    
    
    func focusOrderBarIcon(fromBattleId: Int) {
        for child in orderIconGroup.children {
            if let icon = child as? SKShapeNode {
                icon.fillColor = .gray
            }
        }
        
        for child in orderIconGroup.children {
            if let icon = child as? SKShapeNode {
                if icon.name == String(fromBattleId) {
                    icon.fillColor = .white
                }
            }
        }
    }
    
    func focusAllOrderBarIcons() {
        for child in orderIconGroup.children {
            if let icon = child as? SKShapeNode {
                icon.fillColor = .white
            }
        }
    }
    
    // MARK: - createSkillList
    func createSkillList(view: SKScene) {
        
        skillIconGroup = SKShapeNode(rect: CGRect.init(x: 0, y: 0, width: 375, height: 100), cornerRadius: 10)
        skillIconGroup.strokeColor = .gray
        skillIconGroup.fillColor = .lightGray
        
        skillIconContainer.position = CGPoint(x: 0, y: -100)
        skillIconContainer.zPosition = 2
        skillIconContainer.addChild(skillIconGroup)
        view.addChild(skillIconContainer)
        
        
    }
    
    func updateSkillList(player: Player) {
        
        if skillIconGroup.children.count != 0 {
            skillIconGroup.removeAllChildren()
        }
        
        for i in 0..<player.talentTree.count {
            let skillIcon = SKShapeNode(rectOf: CGSize.init(width: 60, height: 60), cornerRadius: 10)
            skillIcon.position = CGPoint(x: 45 + (i * 70), y: 60)
            skillIcon.name = player.skillName[i]
            let skillLevel = SKLabelNode(text: String(player.talentTree[i]))
            skillLevel.position = CGPoint(x: 20, y: -25)
            skillLevel.fontSize = 14
            skillLevel.fontName = "Copperplate"
            skillLevel.fontColor = .black
            skillIcon.addChild(skillLevel)
            var points = [CGPoint.init(x: 0, y: -30),
                          CGPoint.init(x: 30, y: 0)]
            let skillIconLine = SKShapeNode(points: &points, count: points.count)
            skillIconLine.strokeColor = .black
            skillIcon.addChild(skillIconLine)
            let skillLabel = SKLabelNode(text: player.skillName[i])
            
            skillIcon.strokeColor = .black
            skillLabel.fontColor = .black
            skillLabel.fontSize = 10
            skillLabel.position = CGPoint(x: 50 + (i * 70), y: 10)
            
            skillIconGroup.addChild(skillIcon)
            skillIconGroup.addChild(skillLabel)
            
        }
        
        let moveIn = SKAction.moveTo(y: 0, duration: 0.3)
        moveIn.timingMode = .easeOut
        skillIconContainer.run(moveIn)
        
    }
    
    func resignSkillList() {
        let moveOut = SKAction.moveTo(y: -100, duration: 0.3)
        moveOut.timingMode = .easeOut
        skillIconContainer.run(moveOut)
    }
    
}
