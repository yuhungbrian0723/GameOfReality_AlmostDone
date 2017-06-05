//
//  basicCharacter.swift
//  CharacterModel
//
//  Created by BrianChen on 2017/4/10.
//  Copyright © 2017年 BrianChen. All rights reserved.
//
import UIKit
import SpriteKit

enum StatusName {
    
    case none
    
    //player
    case deffense
    
    //warrior
    case allOutAttack
    case allOutDeffense
    case BasicTactic
    case sympathetic
    
    //bard
    case poisoned
    case dancing
    case singing
    
}



class Status {
    var name:StatusName = .none
    var time = 0
    
}
class Player: SKSpriteNode {
    
    var job = "player"
    var teamSide:Int?   // Parameter: 1 or 2
    var coordinate:(Int,Int)?
    var tileName:String?
    var healthPoint = 1
    var firstHP = 1
    var characterId = 1
    var battleId = 1
    var strength = 1
    var intelligence = 1
    var agility = 1
    var move = 2
    var damagePercentage = 1.0
    var deffensePercentage = 0.0
    var attackRange = 1
    var skillName = ["none","none","none","none","none"]
    var statusBar = [Status]()
    var talentTree = [Int]()
    var skillGroup = [Dictionary<String,String>]()
    var playerTexture : TextureMaster
    var alive = true // true: alive; false: dead
    
    
    private var trm = TileRangeMaker()
    
    let skillReturnData = (AP: Int ,damage:Int ,damageTimes:Int ,status: StatusName ,tileName: [String], isMultipleTargets: Bool).self
    
    init(playerJob job: String) {
        playerTexture = TextureMaster(job: job)
        super.init(texture: playerTexture.standTexture, color: .clear, size: CGSize(width: 60, height: 60))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    /// Get character's skill name and skill number in order to call particular function in player class by using "skillNum" identifier,then the skillGroup property will be availible with many skill
    func getSkillGroup(){
        for i in talentTree {
            switch talentTree[i] {
            case 1:
                let skill = ["skillName":skillName[i],"skillNum":"\(i+1)"]
                skillGroup.append(skill)
                
            default:
                print("")
            }

        }
        
    }

    
    func visitStatusBar(){
        
        var statusBarArray = Array<Int>()
        
        for i in 0..<statusBar.count {
            switch statusBar[i].name {
            case .deffense:
                if statusBar[i].time == 6 {
                    deffensePercentage += 0.2
                    statusBar[i].time -= 1
                } else if 2...5 ~= statusBar[i].time   {
                    statusBar[i].time -= 1
                }else{
//                    dropStatus(withStatusName: .deffense)
                    statusBarArray.append(i)
                }
                
            case .allOutDeffense:
                 if statusBar[i].time == 1 {
                    deffensePercentage += 0.4;
                    statusBar[i].time -= 1
                }else{
//                    dropStatus(withStatusName: .allOutDeffense)
                    statusBarArray.append(i)
                }
            
            case .sympathetic:
                if Double(healthPoint) < Double(firstHP) * 0.5 {
                    damagePercentage += 0.25
                }
                
            case .dancing:
                if statusBar[i].time == 3{
                    deffensePercentage += 0.1
                    healthPoint += Int(Double(healthPoint)*0.1)
                    statusBar[i].time -= 1
                }else if statusBar[i].time == 2 && statusBar[i].time == 1{
                    healthPoint += Int(Double(healthPoint)*0.1)
                    statusBar[i].time -= 1
                }else if statusBar[i].time == 0{
//                    dropStatus(withStatusName: .dancing)
                    statusBarArray.append(i)
                }
                
            case .singing:
                if statusBar[i].time == 3{
                    damagePercentage += 0.1
                    statusBar[i].time -= 1
                }else if statusBar[i].time == 2 && statusBar[i].time == 1 {
                    statusBar[i].time -= 1
                }else if statusBar[i].time == 0{
//                    dropStatus(withStatusName: .singing)
                    statusBarArray.append(i)
                }

            case .poisoned:
                if statusBar[i].time == 3{
                    healthPoint -= Int(Double(healthPoint)*0.05)
                    statusBar[i].time -= 1
                }else if statusBar[i].time == 2 && statusBar[i].time == 1 {
                    healthPoint -= Int(Double(healthPoint)*0.05)
                    statusBar[i].time -= 1
                }else if statusBar[i].time == 0{
//                    dropStatus(withStatusName: .singing)
                    statusBarArray.append(i)
                }
    
            default:
                break
            }
        }
        
        if statusBarArray.count != 0 {
            for index in statusBarArray {
                let statusBarName = statusBar[index].name
                dropStatus(withStatusName: statusBarName)
                
            }
        }
        
        
    }
    
    //check if the character has particular status or not EX:like warrior attacking
    func checkStatus(withName neededStatus:StatusName ) -> Bool {
        
        if statusBar.count == 0 {
            return false
        }
        
        for a in statusBar{
                if a.name != neededStatus {
                    return false
            }
        }
        return true
    }
    
    
    //add status from game logic class
    func addStatus(withStatusName:StatusName){
        let status:Status
        switch withStatusName {
        
        case .deffense:
            status = Status()
            status.name = .deffense
            status.time = 6
            
        case .allOutAttack:
            status = Status()
            status.name = .allOutAttack
            status.time = 2
            
        case .allOutDeffense:
            status = Status()
            status.name = .allOutDeffense
            status.time = 1
            
        case .BasicTactic:
            status = Status()
            status.name = .BasicTactic
            status.time = 1
            
        case .poisoned:
            status = Status()
            status.name = .poisoned
            status.time = 3
            
        case .singing:
            status = Status()
            status.name = .singing
            status.time = 3
            
        case .dancing:
            status = Status()
            status.name = .dancing
            status.time = 3
            
        case .sympathetic:
            status = Status()
            status.name = .sympathetic
            status.time = 1
            
        default:
            status = Status()
            status.name = .none
            
        }
        
        statusBar.append(status)
    }
    
    
    func dropStatus(withStatusName:StatusName){
        switch withStatusName {
            
        case .deffense:
            deffensePercentage -= 0.2
            
        case .allOutDeffense:
            deffensePercentage -= 0.4
            
        case .sympathetic:
            damagePercentage -= 0.25
            
        case .singing:
            damagePercentage -= 0.1
        
        case .dancing:
            deffensePercentage -= 0.1
            
        default:
            break
        }
        
        let changedStatusBar = statusBar.filter({(e)->Bool in
            if (e).name != withStatusName{
                return true
            }else{
                return false
            }
            
        })
        
        statusBar = changedStatusBar
    
    }
    
    
    func shareSpeedToActionBar() -> Double {
        let speed = Double(agility) + Double(strength) * 0.5
        return speed
    }
    
    
    func normalAttack(target:Player) -> (damage:Int,damageTimes:Int) {
        
        let basicDamage = Double(strength)
//        let damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
        let damage = 2_147_483_647 as Int  // Hyperattack for test
        
        target.healthPoint -= damage
        print("Give the target \(damage) damage !")
        print("Target HP: \(target.healthPoint)")
        return (damage,1);
        
    }
    
    
    //basic move for any kind of character,reducing served damge
    func deffense() {
        addStatus(withStatusName: .deffense)
    }
    
    
    func skillOne(target:Player?) -> (AP: Int ,damage:Int ,damageTimes:Int ,status: StatusName ,tileName: [String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
       
        return (1,1,1,.none,[],false,false)
    }
    
    func skillTwo(target:Player?) -> (AP: Int,damage:Int ,damageTimes:Int ,status: StatusName ,tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        return (1,1,1,.none,[],false,false)
    }
    
    
    func skillThree(target:Player?) -> (AP: Int,damage:Int ,damageTimes:Int ,status: StatusName ,tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        return (1,1,1,.none,[],false,false)
    }
    
    func skillFour(target:Player?) -> (AP: Int,damage:Int ,damageTimes:Int ,status: StatusName,tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        return (1,1,1,.none,[],false,false)
    }

    
    func skillFive(target:Player?) -> (AP: Int,damage:Int ,damageTimes:Int ,status: StatusName ,tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        return (1,1,1,.none,[],false,false)
    }


}
