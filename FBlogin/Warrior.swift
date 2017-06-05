//
//  WarriorModel.swift
//  CharacterModel
//
//  Created by BrianChen on 2017/4/4.
//  Copyright © 2017年 BrianChen. All rights reserved.
//
///1.finish skill one and three that are related to Class conditionCenter 

import Foundation
class Warrior:Player{
    
    
    
     var basicHealthPoint = 150.0
     var strengthCoe = 3
     var intelligenceCoe = 1
     var agilityCoe = 2
    
    private var trm = TileRangeMaker()

    init(initDetail:[String : Any]) {
        super.init(playerJob: initDetail["job"] as! String)
        job = initDetail["job"] as! String
        characterId = initDetail["cId"] as! Int
        tileName = initDetail["tileName"] as? String
        let elements = initDetail["elements"] as! Int
        talentTree = initDetail["skills"] as! [Int]
        
//        if talentTree[0] >= 1 {
//           _ = skillOne(selfPlayer: Player(), targets:[Player]())
//        }
//        
//        if talentTree[1] >= 1 {
//            _ = skillTwo(selfPlayer: Player(), targets:[Player]())
//        }
        
        strength = elements * strengthCoe
        intelligence = elements * intelligenceCoe
        agility = elements * agilityCoe
        
        
        healthPoint = Int(basicHealthPoint * Double(NSDecimalNumber(decimal:pow(1.2, Int(Double(elements)/10.0)-1))))
        firstHP = healthPoint
        
        move = 2
        
        skillName = ["基本戰術（被動）","熱血（被動）","掩護(被動)","全面防禦","全面攻擊"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //basic move for any kind of character
    //Use of return damage while some skill's  damage is not only depends on strength
    
    override func normalAttack(target:Player) -> (damage:Int,damageTimes:Int) {
        var basicDamage = Double(strength)
        var damageTimesAtOnce = 1
        if checkStatus(withName: .allOutAttack)  {
            damageTimesAtOnce = 2
            basicDamage = Double(strength)*0.7
            let damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
            target.healthPoint -= damage * 2
            
            return (damage,damageTimesAtOnce)
        }
        let damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
        print("Target HP: \(target.healthPoint)")
        target.healthPoint -= damage
        print("Give the target \(damage) damage !")
        print("Target HP: \(target.healthPoint)")
        
    
        return (damage,damageTimesAtOnce);
    }
    
    

    //
    override func skillOne(target:Player?) ->(AP: Int ,damage:Int ,damageTimes:Int ,status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)?{
        
        addStatus(withStatusName: .BasicTactic)
        
        return (0,0,0,.none,[],false,false)
    }
    
    
    
       
    
    //sympathetic
    override func skillTwo(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        addStatus(withStatusName: .sympathetic)
        return (0,0,0,.none,[],false,false)
    }
    
    
    
    
    //cover
    override func skillThree(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, [String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        
        return (0,0,0,.none,[],false,false)
    }
    
    
    
    //when allOutDeffense activating ,Any kind of damage that warrior is served will reduced 30% in damage calculating phase for 1 round.
    override func skillFour(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        addStatus(withStatusName: .allOutDeffense)
        return (3,0,0,.none,[],false,false)
    }
    
    
    //when allOutAttack activating ,Any kind of damage amount will arise two times in damage calculating phase for 2 rounds.
    //開啟全面攻擊
    override func skillFive(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        addStatus(withStatusName: .allOutAttack)
        return (3,0,0,.none,[],true,false)
    }
    
    
    
    
    
    
    
    
    
    
    
//    func talents(tree:[Int]){
//        switch tree[0] {
//        case 0:
//            
//        default:
//            
//        }
//    }
    
    


}






//               for i in 0..<statusBar!.count {
//            if statusBar![i].name == StatusName.allOutAttack{
//                statusBar?.remove(at: i)
//            }
//        }
