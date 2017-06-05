//
//  FightingMaster.swift
//  creating
//
//  Created by 宋錦淳 on 2017/4/29.
//  Copyright © 2017年 Chinchun. All rights reserved.
//
import SpriteKit
import UIKit

class FightingMaster: NSObject {
    
      
    
      let player = ["player1","player2","player3","player4","player5"]
      let playerImage = ["wizard_stand.png","wizard_step1.png","wizard_step2.png"]
    

     

    func characterCreat(info:Int,team:Int,job:Int,playerName:String)->playInfo{
    var player = playInfo(imageNamed: "goust.png")
        
    switch job {
    case 0:
        player = playInfo(imageNamed: playerImage[0])
    case 1:
        player = playInfo(imageNamed: playerImage[1])
    case 2:
        player = playInfo(imageNamed: playerImage[2])
    default:
        print("Player Init Image wrong!")
    }
    player.name = playerName
    player.id = info
    player.team = team
    return player
    
  }
    
    var teamOne = Array<playInfo>()
    var teamTwo = Array<playInfo>()
    
    func creatPlayerTeam(player:playInfo){
        
        if(player.team == 1){
            teamOne.append(player)
        }else if(player.team == 2){
            teamTwo.append(player)
        }
        
    }
    var battleMenu:Array<SKSpriteNode> = Array(repeating: SKSpriteNode(), count: 4)
    func battleMenu(positionX:Int,positionY:Int){
        
        
        
        let battleMentIconImage = ["sword.png","Shield.png","magic.png","await.png"]
        
        let normalAttackIcon = SKSpriteNode(imageNamed:battleMentIconImage[0])
        normalAttackIcon.position = CGPoint(x:positionX+60,y:positionY)
        normalAttackIcon.name = "attack"
        normalAttackIcon.zPosition = 2
        battleMenu[0] = normalAttackIcon
        let defenceIcon = SKSpriteNode(imageNamed:battleMentIconImage[1])
        defenceIcon.position = CGPoint(x:positionX,y:positionY-60)
        defenceIcon.zPosition = 2
        battleMenu[1] = defenceIcon
        defenceIcon.name = "defence"
        let magicIcon = SKSpriteNode(imageNamed:battleMentIconImage[2])
        magicIcon.position = CGPoint(x:positionX-60,y:positionY)
        magicIcon.zPosition = 2
        battleMenu[2] = magicIcon
        magicIcon.name = "magic"
        let awaitIcon = SKSpriteNode(imageNamed:battleMentIconImage[3])
        awaitIcon.position = CGPoint(x:positionX,y:positionY+60)
        awaitIcon.zPosition = 2
        battleMenu[3] = awaitIcon
        awaitIcon.name = "await"
    }
    
    func removeBattleMenu() {
        battleMenu[0].removeFromParent()
        battleMenu[1].removeFromParent()
        battleMenu[2].removeFromParent()
        battleMenu[3].removeFromParent()
        
    }
    
    func battleMenuPosition(SKNode:SKSpriteNode,SKNode2:SKSpriteNode,SKNode3:SKSpriteNode,SKNode4:SKSpriteNode,positionX:Int,positionY:Int){
        
        
        if(positionX <= 45 && positionY <= 555){
            SKNode.position = CGPoint(x:positionX+60,y:positionY+120)
            SKNode2.position = CGPoint(x:positionX+60,y:positionY+60)
            SKNode3.position = CGPoint(x:positionX+60,y:positionY)
            SKNode4.position = CGPoint(x:positionX+60,y:positionY-60)
        }else if(positionX >= 90 && positionX <= 280 && positionY >= 545 && positionY <= 555){
            SKNode.position = CGPoint(x:positionX-120,y:positionY-60)
            SKNode2.position = CGPoint(x:positionX-60,y:positionY-60)
            SKNode3.position = CGPoint(x:positionX,y:positionY-60)
            SKNode4.position = CGPoint(x:positionX+60,y:positionY-60)
        }else if(positionX >= 330 && positionX <= 360 && positionY >= 170 && positionY <= 560){
            SKNode.position = CGPoint(x:positionX-60,y:positionY+120)
            SKNode2.position = CGPoint(x:positionX-60,y:positionY+60)
            SKNode3.position = CGPoint(x:positionX-60,y:positionY)
            SKNode4.position = CGPoint(x:positionX-60,y:positionY-60)
        }else if(positionX >= 80 && positionX <= 290 && positionY >= 145 && positionY <= 185){
            SKNode.position = CGPoint(x:positionX+120,y:positionY+60)
            SKNode2.position = CGPoint(x:positionX+60,y:positionY+60)
            SKNode3.position = CGPoint(x:positionX,y:positionY+60)
            SKNode4.position = CGPoint(x:positionX-60,y:positionY+60)
            
            
       }
    }
    var actionPoint = 5
    var gemArray = Array<SKSpriteNode>()
    func actionPoint(view:SKScene){
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
        for i in 0...(actionPoint-1){
            gemArray[i].texture = SKTexture(imageNamed: "greenGem.png")
            
        }
        
            print(gemArray.count)

}

    
    func aPRefresh(){
        
        if actionPoint == 0{
            gemArray[0].texture = SKTexture(imageNamed: "gemGray.png")
        }else if (actionPoint > 0){
            for i in 0...(actionPoint-1){
            gemArray[i].texture = SKTexture(imageNamed: "gem.png")
            print("這是一個：\(gemArray[i].texture)")
        }
        for i in actionPoint..<10 {
            gemArray[i].texture = SKTexture(imageNamed: "gemGray.png")
             print("這是一個：\(gemArray[i].texture)")
        }
      }
    }
    
    
    
    func normalAttackFunction(positionX:Int,positionY:Int,view:SKScene){
       
    
        actionPoint -= 1
        print("AP:\(actionPoint)")
        aPRefresh()

        
       
        
        let powerAttack = SKSpriteNode(imageNamed:"powerAttack.png")
        powerAttack.position = CGPoint(x:positionX-60,y:positionY)
        powerAttack.zPosition = 3
        powerAttack.size.height = 40
        powerAttack.size.width = 40
        
        let powerGunAction = SKAction.move(to: CGPoint(x:positionX-120,y:positionY), duration: 0.8)
        powerAttack.run(powerGunAction)
        view.addChild(powerAttack)
        
        print("我要攻擊了")
        
     }
    
    func normaldefence(){
    
        
        
        
        print("進行防禦")
    }


}



class playInfo:SKSpriteNode {
    var id: Int?
    var team: Int?
    var job: Int?
}
