//
//  BardModel.swift
//  CharacterModel
//
//  Created by BrianChen on 2017/4/4.
//  Copyright © 2017年 BrianChen. All rights reserved.
//
/// 1.skill three - AI打自己人,2.技能範圍

import Foundation
class Bard:Player{
    
   
    private var basicHealthPoint = 125.0
    private var strengthCoe = 1
    private var intelligenceCoe = 2
    private var agilityCoe = 3
    
    private var trm = TileRangeMaker()
    private var mcm = MapCoordinateMaster()
    
    
    init(initDetail:[String : Any]) {
        super.init(playerJob: initDetail["job"] as! String)
        job = initDetail["job"] as! String
        characterId = initDetail["cId"] as! Int
        tileName = initDetail["tileName"] as? String
        talentTree = initDetail["skills"] as! [Int]

        let elements = initDetail["elements"] as! Int
        strength = elements * strengthCoe
        intelligence = elements * intelligenceCoe
        agility = elements * agilityCoe
        attackRange  = 3
        healthPoint = Int(basicHealthPoint * Double(NSDecimalNumber(decimal:pow(1.2, Int(Double(elements)/10.0)-1))))
        firstHP = healthPoint
        
        move = 3
        
        skillName = ["弓箭術（被動）","起舞吧，第一小步舞曲","愛麗絲驚魂","吟唱歌曲","魔法毒箭"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func skillOne(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        return (0,0,0,.none,[],false,false)
    }
    
    
    override func skillTwo(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        let tiles = mcm.allTilesName
        if teamSide == target?.teamSide {
            if let target = target {
                target.addStatus(withStatusName: .dancing)
            }
        }
        
        return (3,0,0,.dancing,tiles,true,true)
    }
    
    override func skillThree(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
       
        return (3,0,0,.none,[],false,false)
    }
    
    override func skillFour(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        if let target = target {
            target.addStatus(withStatusName: .singing)
        }
        
        return (3,0,0,.singing,[],false,false)
    }
    
    override func skillFive(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        let basicDamage = Double(strength * 2)
        var damage = Int()

        if let target = target {
            damage = Int(basicDamage*damagePercentage*(1-(target.deffensePercentage)))
            target.addStatus(withStatusName: .poisoned)
        }
        
        return (3,damage,1,.poisoned,[],false,false)
    }

    
    
    
}
