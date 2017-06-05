//
//  conditionCenter.swift
//  CharacterModel
//
//  Created by BrianChen on 2017/4/30.
//  Copyright © 2017年 BrianChen. All rights reserved.
//
//1.詩人addSTATUS 要走CLASS FUNC(要帶CID，跟傷害計算邏輯不一樣，遊戲邏輯要SINGLETON) ／ FUNC RETURN POISON ／player arrraySINGLETON ？
//1.2.data因爲以上
//2.skill func 吐出哼多垃圾
import UIKit

class conditionCenter: NSObject {
    
    
    ///This func is use for Bard's skills,that add status to teamate,
    class func addStatusToTarget (cId:Int, status:StatusName)  {
        //1.find the target character with parameter:cId
        //2.run player class func "addStatus"
    }
    
    
    ///Call  when character moving to any place,to check if there is a warrior nearby
    func ifWarriorNearby(){
        
        //1.run a for loop to check any teamate's coordinate
        //2.if there is one then verify if the teamate is warrior or not
        //3.yes then check its talent tree has skill one,then add beCover status
    
    }
    
    
    ///Call when anyone is attacking enemy.Use to find that if there is a warrior teamate in the position which is in same vertical and horizontal line
    func tacticPosition(enemysCoordinate:Int){
        //1.use warrior's "player class func" to get A:each warrior teamate coordinate,B: if the enemyCoordinate is beside warrior teamate.
        //2.find if the warrior teamate's coordinate is in the position or not,and step 1.B condition is true go on
        //3.call that warrior normal attack
    }
    
    
    

}
