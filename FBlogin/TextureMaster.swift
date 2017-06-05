//
//  TextureMaster.swift
//  TestGame
//
//  Created by yufan-lin on 2017/4/30.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit
import SpriteKit

class TextureMaster: SKTexture {
    
    var standTexture : SKTexture? = nil
    var walkingTexture : [SKTexture]? = nil
    
    
    private let warriorStand = SKTexture.init(imageNamed: "warrior_stand.png")
    private let warriorWakingFrames = [SKTexture.init(imageNamed: "warrior_stand.png"),
                              SKTexture.init(imageNamed: "warrior_step1.png"),
                              SKTexture.init(imageNamed: "warrior_stand.png"),
                              SKTexture.init(imageNamed: "warrior_step2.png")]
    
    private let wizardStand = SKTexture.init(imageNamed: "wizard_stand.png")
    private let wizardWakingFrames = [SKTexture.init(imageNamed: "wizard_stand.png"),
                              SKTexture.init(imageNamed: "wizard_step1.png"),
                              SKTexture.init(imageNamed: "wizard_stand.png"),
                              SKTexture.init(imageNamed: "wizard_step2.png")]
    
    private let bardStand = SKTexture.init(imageNamed: "bard_stand.png")
    private let bardWakingFrames = [SKTexture.init(imageNamed: "bard_stand"),
                              SKTexture.init(imageNamed: "bard_stand.png"),
                              SKTexture.init(imageNamed: "bard_stand"),
                              SKTexture.init(imageNamed: "bard_stand.png")]
    
    init(job: String) {
        super.init()
        playerAppearance(fromPlayerJob: job)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // player1wiz
    
    func playerAppearance(fromPlayerJob job: String) {

        switch job {
        case "warrior":
            standTexture = warriorStand
            walkingTexture = warriorWakingFrames
        case "wizard":
            standTexture = wizardStand
            walkingTexture = wizardWakingFrames
        case "bard":
            standTexture = bardStand
            walkingTexture = bardWakingFrames
        default:
            print("No job found")
        }
    }
    
    func playerWalkingAppearance(fromPlayerName playerName: String) -> [SKTexture]?{
        let jobIndex = playerName.index(playerName.startIndex, offsetBy: 7)
        let job = playerName.substring(from: jobIndex)
        print(job)
        switch job {
        case "war":
            return warriorWakingFrames
        case "wiz":
            return wizardWakingFrames
        case "bar":
            return bardWakingFrames
        default:
            print("No job found")
            return nil
        }
    }
    
    
}
