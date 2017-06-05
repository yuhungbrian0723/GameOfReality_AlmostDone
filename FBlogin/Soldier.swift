//
//  Soldier.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/10.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit
import SpriteKit

enum Job {
    case warrior
    case wizard
    case bard
}

class Soldier: SKSpriteNode {
    var healthPoint = 1
    var job: Job
    var soldierImage = SKTexture(imageNamed: "warrior_stand")
    
    let textLabel = SKLabelNode(fontNamed: "Tahoma")
    
    
    init(job: Job, size: Int) {
        self.job = job
        
        textLabel.fontSize = 12
        textLabel.fontColor = SKColor.red
        textLabel.text = String(describing: job)
        textLabel.position = CGPoint(x: 0, y: -40)
        
        
        super.init(texture: soldierImage, color: .clear, size: CGSize(width: size, height: size))
        addChild(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
