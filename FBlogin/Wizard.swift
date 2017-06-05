//
//  MagicianModel.swift
//  CharacterModel
//
//  Created by BrianChen on 2017/4/4.
//  Copyright © 2017年 BrianChen. All rights reserved.
//
///1.技能範圍

import Foundation
class Wizard:Player{
    
    private var basicHealthPoint = 100.0
    private var strengthCoe = 1
    private var intelligenceCoe = 3
    private var agilityCoe = 2
    
    private var trm = TileRangeMaker()
    private var mcm = MapCoordinateMaster()
    
    
    init(initDetail:[String : Any]) {
        super.init(playerJob: initDetail["job"] as! String)
        job = initDetail["job"] as! String
        characterId = initDetail["cId"] as! Int
        tileName = initDetail["tileName"] as? String
        let elements = initDetail["elements"] as! Int
        talentTree = initDetail["skills"] as! [Int]
        strength = elements * strengthCoe
        intelligence = elements * intelligenceCoe
        agility = elements * agilityCoe
        
        healthPoint = Int(basicHealthPoint * Double(NSDecimalNumber(decimal:pow(1.2, Int(Double(elements)/10.0)-1))))
        firstHP = healthPoint
        
        move = 1
        
        skillName = ["能量衝擊","火塵暴","風裂術","冰結晶","重力場"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func skillOne(target:Player?) -> (AP: Int ,damage:Int ,damageTimes:Int ,status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        let basicDamage = Double(intelligence * 2)
        var damage = Int()
        let tiles = trm.enegyImpactRange(selfTile: tileName!)

        if let target = target {
            damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
        }
        
        return(3,damage,1,.none,tiles,false,false)
    }
    
    
    override func skillTwo(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
    
        let basicDamage = Double(intelligence) * 1.5
        var damage = Int()
        let tiles = trm.fireExplosionRange(selfTile: tileName!)
        
        if let target = target {
            damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
        }

        return (4,damage,0,.none,tiles,true,false)
    }
    
    override func skillThree(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int,  status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        
        let basicDamage = Double(intelligence) * 1.5
        var damage = Int()
        let tiles = trm.windSplitterRange(selfTile: tileName!)
        
        if let target = target {
//            damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
            damage = 2_147_483_647 as Int
        }
        
        return (4,damage,0,.none,tiles,true,false)
    }
    
    override func skillFour(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        let basicDamage = Double(intelligence) * 1.5
        var damage = Int()
        let tiles = trm.waterCrystalRange(selfTile: tileName!)
        
        if let target = target {
                damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
        }
        
        return (4,damage,0,.none,tiles,true,false)
    }
    
    override func skillFive(target:Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {
        let basicDamage = Double(intelligence) * 1.5
        var damage = Int()
        let tiles = mcm.allTilesName
        
        if let target = target {
//            damage = Int(basicDamage*damagePercentage*(1-target.deffensePercentage))
            damage = 999_999_999
        }
        
        return (5,damage,0,.none,tiles,true,false)
    }

    
    
}
