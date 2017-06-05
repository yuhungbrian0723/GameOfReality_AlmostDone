//
//  gamePlayersCreate.swift
//  TestGame
//
//  Created by 宋錦淳 on 2017/5/3.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import Foundation
import SpriteKit

class gamePlayersCreate:SKScene {
    
    let sendPlayer = GameScene()
    
    var playbtn:SKSpriteNode?
    var creatPlayerArea:SKSpriteNode?
    
    var playerCreate01:SKSpriteNode?
    var playerCreate02:SKSpriteNode?
    var playerCreate03:SKSpriteNode?
    var playerCreate04:SKSpriteNode?
    var playerCreate05:SKSpriteNode?

    var playerCreateArray = ["cId":0,
                             "job":"warrior",
                             "elements": 0,
                             "skills":[0,0,0,0,0]] as [String : Any]
    
    
    var arrangmentPrototype = [Dictionary<String, Any>]()
    
    
    var sword:SKSpriteNode?
    var magic:SKSpriteNode?
    var bow:SKSpriteNode?
    var plus:SKLabelNode?
    var reduce:SKLabelNode?
    var number:SKLabelNode?
    var numberShow:SKSpriteNode?
    var bag01:SKSpriteNode?
    var bag02:SKSpriteNode?
    var oK:SKLabelNode?
    
    var skill01:SKSpriteNode?
    var skill02:SKSpriteNode?
    var skill03:SKSpriteNode?
    var skill04:SKSpriteNode?
    var skill05:SKSpriteNode?
    
    
     override func didMove(to view: SKView) {
        print(playerCreateArray)
     CreateTheView()
        
    }
    var selectedName = "nothing"
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let location = touch?.location(in: view)
        let gameLocation = convertPoint(fromView: location!)
        //        print("X: \(gameLocation.x), Y: \(gameLocation.y)")
        let objs = nodes(at: gameLocation)
        selectedName = objs.first?.name ?? selectedName
        print(selectedName)
      
        if selectedName == "play"{
            UserDefaults.standard.set(arrangmentPrototype, forKey: "player")
            UserDefaults.standard.synchronize()
            playbtn?.texture = SKTexture(imageNamed: "PlayButtonPressed.png")
            playbtn?.readyBtn(view: self.view!)
       
        }
        
          chiose(coioseName: selectedName)
          print(playerCreateArray)
        
    
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let location = touch?.location(in: view)
        let gameLocation = convertPoint(fromView: location!)
        //        print("X: \(gameLocation.x), Y: \(gameLocation.y)")
        let objs = nodes(at: gameLocation)
        selectedName = objs.first?.name ?? selectedName
        oK?.isHidden = false
        
        
        if selectedName == "oK"{
        arrangmentPrototype.append(playerCreateArray)
        print(arrangmentPrototype)
            
            
        }
        
    }
    
    
    
    func chiose(coioseName:String){
    
    if coioseName == "playerCreate01"{
        playerIdInput(arrayNumber: 0, cId: 1)
        creatPlayerArea?.isHidden = false
        showPorfession()
    }else if coioseName == "playerCreate02"{
        playerIdInput(arrayNumber: 0, cId: 2)
        creatPlayerArea?.isHidden = false
        showPorfession()
    }else if coioseName == "playerCreate03"{
        playerIdInput(arrayNumber: 0, cId: 3)
        creatPlayerArea?.isHidden = false
        showPorfession()
    }else if coioseName == "playerCreate04"{
        playerIdInput(arrayNumber: 0, cId: 4)
        creatPlayerArea?.isHidden = false
        showPorfession()
    }else if coioseName == "playerCreate05"{
        playerIdInput(arrayNumber: 0, cId: 5)
        creatPlayerArea?.isHidden = false
        showPorfession()
    
        }
    
        
        jobSelect(arrayNumber: 0)
        showPlusAndReduce()
        plusAndReduce(arrayNumber: 0)
        showSkillBtn()
        skillChiose(arrayNumber: 0)
    
        
   }
    



        func CreateTheView(){
            
            playbtn = childNode(withName: "play")as? SKSpriteNode
            creatPlayerArea = childNode(withName: "createPlayersArea")as? SKSpriteNode
            creatPlayerArea?.isHidden = true
            
            oK = childNode(withName: "oK")as? SKLabelNode
            oK?.isHidden = true
            
            playerCreate01 = childNode(withName: "playerCreate01")as? SKSpriteNode
            playerCreate02 = childNode(withName: "playerCreate02")as? SKSpriteNode
            playerCreate03 = childNode(withName: "playerCreate03")as? SKSpriteNode
            playerCreate04 = childNode(withName: "playerCreate04")as? SKSpriteNode
            playerCreate05 = childNode(withName: "playerCreate05")as? SKSpriteNode
          
            
            
            
            sword = childNode(withName: "sword")as? SKSpriteNode
            sword?.isHidden = true
            magic = childNode(withName: "magic")as? SKSpriteNode
            magic?.isHidden = true
            bow = childNode(withName: "bow")as? SKSpriteNode
            bow?.isHidden = true
            plus = childNode(withName: "plus")as? SKLabelNode
            plus?.isHidden = true
            reduce = childNode(withName: "reduce")as? SKLabelNode
            reduce?.isHidden = true
            number = childNode(withName: "number")as? SKLabelNode
            number?.isHidden = true
            numberShow = childNode(withName: "numberShow")as? SKSpriteNode
            numberShow?.isHidden = true
            bag01 = childNode(withName: "bag01")as? SKSpriteNode
            bag01?.isHidden = true
            bag02 = childNode(withName: "bag02")as? SKSpriteNode
            bag02?.isHidden = true
            
            skill01 = childNode(withName: "skill01")as? SKSpriteNode
            skill01?.isHidden = true
            skill02 = childNode(withName: "skill02")as? SKSpriteNode
            skill02?.isHidden = true
            skill03 = childNode(withName: "skill03")as? SKSpriteNode
            skill03?.isHidden = true
            skill04 = childNode(withName: "skill04")as? SKSpriteNode
            skill04?.isHidden = true
            skill05 = childNode(withName: "skill05")as? SKSpriteNode
            skill05?.isHidden = true


        }
         func showPorfession() {
            
            sword?.isHidden = false
            magic?.isHidden = false
            bow?.isHidden = false

         }
        func showPlusAndReduce () {
            plus?.isHidden = false
            reduce?.isHidden = false
            number?.isHidden = false
            numberShow?.isHidden = false
            bag01?.isHidden = false
            bag02?.isHidden = false
        }
        func showSkillBtn () {
            skill01?.isHidden = false
            skill02?.isHidden = false
            skill03?.isHidden = false
            skill04?.isHidden = false
            skill05?.isHidden = false
    }

    
    
    
    
    
    func playerIdInput(arrayNumber:Int,cId:Int){
         playerCreateArray.updateValue(cId, forKey: "cId")
       
    }
    func playerJobInput(arrayNumber:Int,job:String){
         playerCreateArray.updateValue(job, forKey: "job")
    }
    
    func playerElementInput(arrayNumber:Int,elements:Int){
         playerCreateArray.updateValue(elements, forKey: "elements")
    }
    func playerSkillsInput(arrayNumber:Int,skills01:Int,skills02:Int,skills03:Int,skills04:Int,skills05:Int){

         playerCreateArray.updateValue([skills01,skills02,skills03,skills04,skills05], forKey: "skills")
       
    }
    
    
    
    
    
    func jobSelect(arrayNumber:Int){
        
       if selectedName == "sword"{
             playerJobInput(arrayNumber: arrayNumber,job:"warrior")
        }
       if selectedName == "magic" {
                playerJobInput(arrayNumber: arrayNumber, job:"wizard")
        }
       if selectedName == "bow"{
                playerJobInput(arrayNumber: arrayNumber, job:"bard")
      }
    }

    
    
    var elements = 0
    func plusAndReduce(arrayNumber:Int){
        if selectedName == "plus"{
            elements += 10
            playerElementInput(arrayNumber: arrayNumber, elements: elements)
            print(elements)
    }else if selectedName == "reduce"{
            elements -= 10
            if elements <= 0{
                elements = 0
            }
            playerElementInput(arrayNumber: arrayNumber, elements: elements)
            print(elements)

      }
    }
    
    var skillPoint01 = 0
    var skillPoint02 = 0
    var skillPoint03 = 0
    var skillPoint04 = 0
    var skillPoint05 = 0
    func skillChiose(arrayNumber:Int){
        
        if selectedName == "skill01"{
            skillPoint01 += 1
            playerSkillsInput(arrayNumber: arrayNumber, skills01: skillPoint01, skills02: skillPoint02, skills03: skillPoint03,skills04: skillPoint04,skills05: skillPoint05)
            print(skillPoint01)
        }else if selectedName == "skill02"{
            skillPoint02 += 1
            print(skillPoint02)
            playerSkillsInput(arrayNumber: arrayNumber, skills01: skillPoint01, skills02: skillPoint02, skills03: skillPoint03,skills04: skillPoint04,skills05: skillPoint05)
        }else if selectedName == "skill03"{
            skillPoint03 += 1
            print(skillPoint03)
            playerSkillsInput(arrayNumber: arrayNumber, skills01: skillPoint01, skills02: skillPoint02, skills03: skillPoint03,skills04: skillPoint04,skills05: skillPoint05)
        }else if selectedName == "skill04"{
            skillPoint04 += 1
            print(skillPoint04)
            playerSkillsInput(arrayNumber: arrayNumber, skills01: skillPoint01, skills02: skillPoint02, skills03: skillPoint03,skills04: skillPoint04,skills05: skillPoint05)
        }else if selectedName == "skill05"{
            skillPoint05 += 1
            print(skillPoint05)
            playerSkillsInput(arrayNumber: arrayNumber, skills01: skillPoint01, skills02: skillPoint02, skills03: skillPoint03,skills04: skillPoint04,skills05: skillPoint05)
        }else{
            print("somethings wrong!")

        }
    }
}

extension SKSpriteNode{
    func readyBtn(view:SKView){
        
        if let scene = SKScene(fileNamed: "GameScene"){
            scene.scaleMode = .aspectFill
            
        let otherTransition = SKTransition.doorway(withDuration: 0.8)
            
//        let mytransition = SKTransition.push(with: .left, duration: 0.5)
            view.presentScene(scene,transition:otherTransition)
        }
    }
}
