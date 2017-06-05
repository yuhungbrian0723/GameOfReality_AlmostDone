//
//  CharacterModel.swift
//  CharacterModel
//
//  Created by BrianChen on 2017/4/2.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit

class TeamArrangementCenter:NSObject {
    
    var arrangmentPrototype:[Dictionary<String, Any>] = []
    
    //creating every characters one by one from team arrangementPrototypes
    func createTeamCharacters(organzieWithArrangement:[Dictionary<String, Any>]) -> [Player]{
        
        var teamQueue = [Player]()//給同學的角色陣列
        for i in 0..<organzieWithArrangement.count {
            switch organzieWithArrangement[i]["job"] as! String {
            case "warrior":
                print("hey im warrior")
                let warrior = Warrior(initDetail:organzieWithArrangement[i])
                teamQueue.append(warrior)
                
            case "wizard":
                print("hey im wizaed")
                let wizard = Wizard(initDetail:organzieWithArrangement[i])
                teamQueue.append(wizard)
                
            case "bard":
                print("hey im bard")
                let bard = Bard(initDetail:organzieWithArrangement[i])
                teamQueue.append(bard)
                
            default:
                print("wrong occupation type")
                
            }
        }
        return teamQueue
    }
    
    
    
    
    
}




/* [{
 "id" : 1,
 "job" : "warrior",
 "element" : 10,
 "skills" : [2,2,2,0,0],
 },
 {
 
 },
 {
 
 },
 {
 
 },
 {
 
 }
 ]*/
