//
//  PlayerData.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/3.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit

class PlayerData: NSObject {
//    var teamOnePlayers = [Dictionary<String, Any>]()
    
//    override init() {
//        super.init()
//        let userDefaults = UserDefaults.standard
//        teamOnePlayers = userDefaults.array(forKey: "player") as! [Dictionary<String, Any>]
//        
//        print("這是我的觀察：\(teamOnePlayers)")
//    }
    let teamOnePlayers = [
        [
            "cId" : 1,
            "job" : "bard",
            "elements" : 200,
            "skills" : [1, 1, 1, 1, 1],
            "tileName" : "tile00"
        ],
        [
            "cId" : 2,
            "job" : "bard",
            "elements" : 200,
            "skills" : [1, 1, 1, 1, 1],
            "tileName" : "tile11"
        ],
        [
            "cId" : 3,
            "job" : "wizard",
            "elements" : 200,
            "skills" : [2, 2, 2, 1, 1],
            "tileName" : "tile20"
        ],
        [
            "cId" : 4,
            "job" : "warrior",
            "elements" : 200,
            "skills" : [1, 1, 4, 1, 1],
            "tileName" : "tile31"
        ],
        [
            "cId" : 5,
            "job" : "wizard",
            "elements" : 220,
            "skills" : [1, 2, 1, 1, 1],
            "tileName" : "tile40"
        ]
    ]
    
    let teamTwoPlayers = [
        [
            "cId" : 6,
            "job" : "bard",
            "elements" : 200,
            "skills" : [1, 1, 1, 1, 1],
            "tileName" : "tile01"
        ],
        [
            "cId" : 7,
            "job" : "warrior",
            "elements" : 200,
            "skills" : [0, 1, 1, 1, 1],
            "tileName" : "tile46"
        ],
        [
            "cId" : 8,
            "job" : "wizard",
            "elements" : 200,
            "skills" : [2, 1, 5, 1, 1],
            "tileName" : "tile37"
        ],
        [
            "cId" : 9,
            "job" : "warrior",
            "elements" : 200,
            "skills" : [1, 2, 1, 1, 1],
            "tileName" : "tile26"
        ],
        [
            "cId" : 10,
            "job" : "bard",
            "elements" : 220,
            "skills" : [1, 3, 3, 8, 1],
            "tileName" : "tile17"
        ]
    ]

    //[player, player] bl lm
    // player0wizardbl
    // player0wizardbl
    
}
