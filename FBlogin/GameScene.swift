//
//  GameScene.swift
//  TestGame
//
//  Created by yufan-lin on 2017/4/24.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit


class GameScene: SKScene {
    
    // Appearance's parameters in game.
    private var deviceWidth = 0
    private var tileLength = 0
    private var PositionX = 0
    private var viewMargin = 0
    
    // Relative to map parameters
    private var allTilesName = Array<String>()
    private var mapCoorPosX = Array<Int>()
    private var mapCoorPosY = Array<Int>()
    
    private var tileArray = Array<SKShapeNode>()
    
    
    
    // Relative to player's information
    private var playersPositionTileArray = Array<String>()
    
    private var playerObjs : [Player]?
    
    private var wizardWalkFrames = Array<SKTexture>()
    
    // Instantiate classes
    private let tac = TeamArrangementCenter()
    private let playerData = PlayerData()
    private let pcm = PlayerCreationMaster()
    private let fm = FightingMaster()
    private var mcm = MapCoordinateMaster()
    private let em = EffectMaster()
    private let gcm = GameCoreMaster()
    private let bi = BattleInterface()
    
    override func didMove(to view: SKView) {
        
        
        mcm = MapCoordinateMaster(deviceWidth: Int(self.frame.width))
        
        
//        print("mapCoorPosX: \(mcm.mapCoorPosX)")
//        print("mapCoorPosY: \(mcm.mapCoorPosY)")

        deviceWidth = Int(self.frame.width)
        tileLength = mcm.tileLength
        viewMargin = mcm.viewMargin
        self.view?.isMultipleTouchEnabled = false
        
        allTilesName = mcm.allTilesName
        mapCoorPosX = mcm.mapCoorPosX
        mapCoorPosY = mcm.mapCoorPosY
        
        // Create map tiles
        createTiles()
        
        print(self.mapCoorPosX)
        print(self.mapCoorPosY)
        print(deviceWidth)
        
        // Soldier status information bar
        bi.createMainContainer(view: scene!, deviceWidth: deviceWidth, deviceHeight: 200)
        
        
        // Create action point bar
        bi.createActionPoint(view: scene!, actionPoint: gcm.actionPoint)
        
        
        // Create players
        
        
        
        // Create characters from CharacterCenter
        var playerCreationData = playerData.teamOnePlayers
        playerCreationData.append(contentsOf: playerData.teamTwoPlayers)
        
        print(playerCreationData)
        playerObjs = tac.createTeamCharacters(organzieWithArrangement: playerCreationData)
        
        let bgView = SKTexture(imageNamed: "bg01.png")
        let bgSKNode = SKShapeNode(rect: CGRect(x: -1, y: -1, width: 377, height: 675))
        bgSKNode.fillTexture = bgView
        bgSKNode.fillColor = .white
        scene?.addChild(bgSKNode)
//
        
        var battleId = 1
        for i in 0..<playerObjs!.count {
            playerObjs?[i].position = mcm.getPosition(fromTileName: playerObjs![i].tileName!)
            playersPositionTileArray.append((playerObjs?[i].tileName!)!)
            
            if i < playerData.teamOnePlayers.count {
                let border = SKShapeNode(rect: CGRect.init(x: -30, y: -30, width: 60, height: 60), cornerRadius: 10)
                border.strokeColor = .blue
                playerObjs?[i].teamSide = 1
                playerObjs?[i].battleId = battleId
                playerObjs?[i].addChild(border)
                battleId += 1
            } else {
                let border = SKShapeNode(rect: CGRect.init(x: -30, y: -30, width: 60, height: 60), cornerRadius: 10)
                border.strokeColor = .red
                playerObjs?[i].teamSide = 2
                playerObjs?[i].battleId = battleId
                playerObjs?[i].addChild(border)
                battleId += 1
            }

            addChild((playerObjs?[i])!)
        }
        print(playersPositionTileArray)
        checkPlayerData()
        
        // Order players' priority
        gcm.playerSequenceOrder(players: playerObjs!)
        
        // Game turn start counting
        
      
        print(gcm.playersOrderId)
        
        bi.createActionOrderBar(view: scene!, players: playerObjs!, solderOrderId: gcm.playersOrderId)
   
        bi.createSkillList(view: scene!)
        
        
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(sender:)))
        let panAction = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:)))
        
        self.view?.addGestureRecognizer(tapAction)
        self.view?.addGestureRecognizer(panAction)
        
        bi.focusAllOrderBarIcons()
       
        turnStart()
        
    }   // ============= End of didMove ============================================================
    
    private var selectedName: String?
    private var prePosition: CGPoint?
    private var moveToTiles = Array<String>()
    private var selectedSoldier:Player?
    private var actionSoldier:Player?
//    private var targetSoldier:Player?
    
    private var preTile: SKShapeNode?
    private var curTile: SKShapeNode?
    
    /**
     Parameter:
     - 1 : normal
     - 2 : target selection
     - 3 : execute normal attack
     - 4 : select skill
     - 5 : execute skill
     */
    private var actionMode = 1
    
    private var selectedSkill: Int?
    
    private var isDidMove = false
    
    
    // MARK:- UITapGestureRecognizer
    func tapAction(sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let gameLocation = convertPoint(fromView: location)
        let objs = nodes(at: gameLocation)
        
        fm.removeBattleMenu()
        
        print("PlayerOrderId: \(gcm.playersOrderId)")
        
        // MARK: ActionMode: 1
        if actionMode == 1 {

//            clearTilesColor()
            if let soldier = atPoint(gameLocation) as? Player{
                print("Job: \(soldier.job), HP: \(soldier.healthPoint), Alive: \(soldier.alive)")
                print("Name: \(soldier.battleId)")
                actionSoldier = soldier 
            } else {
                
            }
         
            preTile = objs.last as? SKShapeNode
            
            
            guard let thisPlayer = atPoint(gameLocation).parent as? Player else {
                
                if let headIcon = atPoint(gameLocation) as? SKShapeNode {
                    
                    selectNothing()
                    
                    if let i = playerObjs?.index(where: {String($0.battleId) == headIcon.name}) {
                        focusCurrentSoldier(currentSoldier: (playerObjs?[i])!, allSoldiers: playerObjs!)
                        bi.focusOrderBarIcon(fromBattleId: Int(headIcon.name!)!)
                        bi.idLabel.text = "ID: \((playerObjs?[i])!.battleId)"
                        bi.healthPointLabel.text = "HP: \((playerObjs?[i])!.healthPoint) / \((playerObjs?[i])!.firstHP)"
                        changeCurrentSoldierTileColor()
                    } else {
                        actionSoldier = nil
                        focusAllSoldier(allSoldiers: playerObjs!)
                        fm.removeBattleMenu()
                        bi.focusAllOrderBarIcons()
                        changeCurrentSoldierTileColor()
                        return
                    }
                    
                    return
                }
                
                return
            }
            
            guard thisPlayer.alive else {
                print("Are you zombie??")
                return
            }
            
            for status in thisPlayer.statusBar {
                print("statusbar | name: \(status.name), time: \(status.time)")
            }
            
            print("Def: \(thisPlayer.deffensePercentage), Def turn remaining: \(thisPlayer.statusBar.last?.time)")
            print("Skills: \(thisPlayer.talentTree)")
            actionSoldier = thisPlayer
            focusCurrentSoldier(currentSoldier: thisPlayer, allSoldiers: playerObjs!)
            
            bi.idLabel.text = "ID: \(thisPlayer.battleId)"
            bi.healthPointLabel.text = "HP: \(thisPlayer.healthPoint) / \(thisPlayer.firstHP)"
            bi.focusOrderBarIcon(fromBattleId: thisPlayer.battleId)
            
            print("Soldier Id: \(gcm.currentSoldierActionId) is on turn")
            guard gcm.currentSoldierActionId == thisPlayer.battleId else {
                actionMode = 1
                return
            }
            
            
            actionMode = 2
            
            prePosition = actionSoldier?.position
            
            print("TeamSide: \(String(describing: thisPlayer.teamSide))")
            
            
            fm.battleMenu(positionX: Int(thisPlayer.position.x), positionY: Int(thisPlayer.position.y))
            self.addChild(fm.battleMenu[0])
            self.addChild(fm.battleMenu[1])
            self.addChild(fm.battleMenu[2])
            self.addChild(fm.battleMenu[3])
            
        // MARK: ActionMode: 2
        } else if actionMode == 2 {
            selectedName = objs.first?.name ?? selectedName
            focusAllSoldier(allSoldiers: playerObjs!)
            bi.focusAllOrderBarIcons()
            guard let actionName = selectedName else {
                actionMode = 1
                return
            }
            
            guard actionName != "attack" || actionName != "defence" || actionName != "await" || actionName != "magic" else {
                actionMode = 1
                
                return
            }
            
            
            switch actionName {
            case "attack":
                guard gcm.actionPoint >= 2 else {
                    print("Your action point is not enough !")
                    actionMode = 1
                    return
                }
                
                print("\(actionSoldier?.job) attack: \(actionSoldier?.damagePercentage)")
                var attackTileRange = mcm.getTilesRangeAvailable(distance: (actionSoldier?.attackRange)!, myTileIndexs: mcm.getTileIndexs(fromTileName: (actionSoldier?.tileName)!)!)
                print("Attack range: \(actionSoldier?.attackRange)")
                let myTileIndex = attackTileRange.index(of: (actionSoldier?.tileName)!)
                attackTileRange.remove(at: myTileIndex!)
                changeTilesColor(tileNames: attackTileRange, toColor: .red)
                actionMode = 3
                
            case "defence":
                guard gcm.actionPoint >= 1 else {
                    print("Your action point is not enough !")
                    actionMode = 1
                    actionSoldier = nil
                    return
                }
                
                guard !(actionSoldier?.checkStatus(withName: .deffense))! else {
                    print("actionSoldier: \(actionSoldier)")
                    print("Your have been cast deffence !")
                    actionMode = 1
                    actionSoldier = nil
                    return
                }
                
                print("defence")
                actionSoldier?.addStatus(withStatusName: .deffense)
                checkPlayerData()
                gcm.actionPoint -= 1
                bi.updateActionPoint(actionPoint: gcm.actionPoint)
                
                
                em.deffenceEffect(selfPlayer: actionSoldier!, view: scene!)
                
                timeWating(forDuration: 1)
                
                
            case "await":
                print("await")
                
                turnChange()
                
            case "magic":
                print("magic")
                bi.updateSkillList(player: actionSoldier!)
                actionMode = 4
                
            default:
                selectedName = nil
                actionMode = 1
                changeCurrentSoldierTileColor()
                break;
                }
            
            selectedName = nil
            fm.removeBattleMenu()
            
        // MARK: ActionMode: 3
        } else if actionMode == 3 {
            
            guard let targetSoldier = atPoint(gameLocation).parent as? Player else {
                print("Not target found")
                actionMode = 1
                actionSoldier = nil
                clearTilesColor()
                changeCurrentSoldierTileColor()
                
                return
            }
            
            var attackTileRange = mcm.getTilesRangeAvailable(distance: (actionSoldier?.attackRange)!, myTileIndexs: mcm.getTileIndexs(fromTileName: (actionSoldier?.tileName)!)!)
            let myTileIndex = attackTileRange.index(of: (actionSoldier?.tileName)!)
            attackTileRange.remove(at: myTileIndex!)
            
            guard isTileValidInArray(targetTile: targetSoldier.tileName!, availableTiles: attackTileRange) else {
                print("Target is out of range")
                actionMode = 1
                actionSoldier = nil
                clearTilesColor()
                changeCurrentSoldierTileColor()
                
                return
            }
            
            guard targetSoldier.teamSide != actionSoldier?.teamSide else {
                print("You can not attack your teammate !")
                return
            }
            
            print("Target HP: \(targetSoldier.healthPoint)")
            
            let damageValue = actionSoldier!.normalAttack(target: targetSoldier).damage
            em.beatenEffect(targetSoldier: targetSoldier, damageValue: damageValue, scene: self)
            
            clearTilesColor()
            
            actionSoldier = nil
            
            gcm.actionPoint -= 2
            bi.updateActionPoint(actionPoint: gcm.actionPoint)
            
            checkSoldierAlive(allSoldier: playerObjs!)
            
        
        // MARK: ActionMode: 4
        } else if actionMode == 4 {
            bi.resignSkillList()
            
            guard let skill = atPoint(gameLocation) as? SKShapeNode else {
                actionMode = 1
                return
            }
            
            print("Skill: \(skill)")
            
            print("SkillName: \(actionSoldier?.skillName)")
            
            if let i = actionSoldier?.skillName.index(where: {$0 == skill.name}) {
                guard actionSoldier?.talentTree[i] != 0 else {
                    actionMode = 1
                    print("Do not have [\(skill.name!)] skill.")
                    return
                }
                
                switch i {
                case 0:
                    var attackTileRange = actionSoldier?.skillOne(target: nil)?.tileName
                    if let i = attackTileRange?.index(of: (actionSoldier?.tileName)!) {
                        attackTileRange?.remove(at: i)
                    }
                    changeTilesColor(tileNames: attackTileRange!, toColor: .red)
                    actionMode = 5
                    selectedSkill = 0
                    return
                    
                case 1:
                    var attackTileRange = actionSoldier?.skillTwo(target: nil)?.tileName
                    if let i = attackTileRange?.index(of: (actionSoldier?.tileName)!) {
                        attackTileRange?.remove(at: i)
                    }
                    changeTilesColor(tileNames: attackTileRange!, toColor: .red)
                    actionMode = 5
                    selectedSkill = 1
                    return
                    
                case 2:
                    var attackTileRange = actionSoldier?.skillThree(target: nil)?.tileName
                    if let i = attackTileRange?.index(of: (actionSoldier?.tileName)!) {
                        attackTileRange?.remove(at: i)
                    }
                    changeTilesColor(tileNames: attackTileRange!, toColor: .red)
                    actionMode = 5
                    selectedSkill = 2
                    return
                    
                case 3:
                    var attackTileRange = actionSoldier?.skillFour(target: nil)?.tileName
                    if let i = attackTileRange?.index(of: (actionSoldier?.tileName)!) {
                        attackTileRange?.remove(at: i)
                    }
                    changeTilesColor(tileNames: attackTileRange!, toColor: .red)
                    actionMode = 5
                    selectedSkill = 3
                    return
                    
                case 4:
                    var attackTileRange = actionSoldier?.skillFive(target: nil)?.tileName
                    if let i = attackTileRange?.index(of: (actionSoldier?.tileName)!) {
                        attackTileRange?.remove(at: i)
                    }
                    changeTilesColor(tileNames: attackTileRange!, toColor: .red)
                    actionMode = 5
                    selectedSkill = 4
                    return
                    
                default:
                    actionMode = 1
                }
                
            }
            actionMode = 1
            
        // MARK: ActionMode: 5
        } else if actionMode == 5 {
            
            let skill = skillSelection(actionSoldier: actionSoldier!, skillIndex: selectedSkill!, targetPlayer: nil)
            print("SelectSkill: \(selectedSkill)")
            guard gcm.actionPoint >= (skill?.AP)! else {
                actionMode = 1
                print("Action point is not enogh !")
                return
            }
            
            if skill?.isMultipleTargets == false {
                guard let targetSoldier = atPoint(gameLocation).parent as? Player else {
                    print("No target found")
                    actionMode = 1
                    actionSoldier = nil
                    selectedSkill = nil
                    clearTilesColor()
                    changeCurrentSoldierTileColor()
                    
                    return
                }
                
                skillPostattack(actionSoldier: actionSoldier!, skillIndex: selectedSkill!, targetSoldier: [targetSoldier])
                
            } else if skill?.isMultipleTargets == true {
                guard let targetSoldier = atPoint(gameLocation).parent as? Player else {
                    print("No target found")
                    actionMode = 1
                    actionSoldier = nil
                    selectedSkill = nil
                    clearTilesColor()
                    changeCurrentSoldierTileColor()

                    return
                }
                
                let targetRangeTiles = skill?.tileName
                let targetPlayers = selectPlayers(fromTileArray: targetRangeTiles!)
                
                skillPostattack(actionSoldier: actionSoldier!, skillIndex: selectedSkill!, targetSoldier: targetPlayers)
                
            }
            
            
            
            actionMode = 1
            selectedSkill = nil
            
        }
        print("actionMode: \(actionMode)")
    }
    
    // MARK:- UIPanGestureRecognizer
    func panAction(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        let gameLocation = convertPoint(fromView: location)
        
        fm.removeBattleMenu()
        
        
        if sender.state == .began {
            if let soldier = atPoint(gameLocation).parent as? Player{
                
                guard soldier.battleId == gcm.currentSoldierActionId else {
                    return
                }
                
                guard !isDidMove else {
                    return
                }
                
                print("Job: \(soldier.job), HP: \(soldier.healthPoint)")
                print("Name: \(soldier.battleId)")
                selectedSoldier = soldier
                playerBeginMove()
                moveToTiles = mcm.getTilesRangeAvailable(distance: soldier.move, myTileIndexs: mcm.getIndexs(fromPostion: prePosition!)!)
                clearTilesColor()
                changeTilesColor(tileNames: moveToTiles, toColor: UIColor.green)
            }
            
        }
        
        if sender.state == .changed {
            playerDidMove(location: gameLocation)
        }
        
        if sender.state == .ended {
            playerEndMove(location: gameLocation)
            
        }
            
        
    }
    
    
    // MARK: - Skill Selection
    func skillSelection(actionSoldier: Player, skillIndex: Int, targetPlayer: Player?) -> (AP: Int, damage: Int, damageTimes: Int, status: StatusName, tileName:[String], isMultipleTargets: Bool, isSameTeammate: Bool)? {

        switch skillIndex {
        case 0:
            return actionSoldier.skillOne(target: targetPlayer)
            
        case 1:
            return actionSoldier.skillTwo(target: targetPlayer)
            
        case 2:
            return actionSoldier.skillThree(target: targetPlayer)
            
        case 3:
            return actionSoldier.skillFour(target: targetPlayer)
            
        case 4:
            return actionSoldier.skillFive(target: targetPlayer)
            
        default:
            
            break
        }
        return nil
    }
    
    
    func skillPostattack(actionSoldier: Player, skillIndex: Int, targetSoldier: [Player]) {
        
        let skill = skillSelection(actionSoldier: actionSoldier, skillIndex: skillIndex, targetPlayer: targetSoldier.first)
        
        var attackTileRange = skill?.tileName
        
        var isSkillExecuteSuccess = false
        
        if let i = attackTileRange?.index(where: {$0 == actionSoldier.tileName}) {
            attackTileRange?.remove(at: i)
        }
        
        for soldier in targetSoldier {
            
            let executeSkill = skillSelection(actionSoldier: actionSoldier, skillIndex: skillIndex, targetPlayer: soldier)
            
            guard soldier.alive == true else {
                print("You can not attack dead people")
                actionMode = 1
                
                continue
            }
            
            
            guard isTileValidInArray(targetTile: soldier.tileName!, availableTiles: attackTileRange!) else {
                print("Target is out of range")
                actionMode = 1
                
                continue
            }
            
            guard (soldier.teamSide == actionSoldier.teamSide) == skill?.isSameTeammate else {
                print("You can not attack your teammate !")
                actionMode = 1
                continue
            }
            
            print("Target HP: \(soldier.healthPoint)")
            
            if skill?.isSameTeammate == true {
                
            } else {
                let damageValue = executeSkill?.damage
                soldier.healthPoint -= (damageValue)!
                em.beatenEffect(targetSoldier: soldier, damageValue: (damageValue)!, scene: self)
            }
            
            
            
            isSkillExecuteSuccess = true
        }
        
        
        
        if isSkillExecuteSuccess {
            gcm.actionPoint -= (skill?.AP)!
            bi.updateActionPoint(actionPoint: gcm.actionPoint)
            checkSoldierAlive(allSoldier: playerObjs!)
            clearTilesColor()
        } else {
            clearTilesColor()
            changeCurrentSoldierTileColor()
        }
        
        
    }
    

    // MARK: - Move Function
    func playerBeginMove() {
        actionMode = 1
        guard let thisPlayer = selectedSoldier else {
            return
        }
        if let i = thisPlayer.children.index(where: {$0 is SKShapeNode}) {
            let border = thisPlayer.children[i] as! SKShapeNode
            border.strokeColor = .clear
            
        }
        prePosition = thisPlayer.position
        thisPlayer.setScale(1.2)
        thisPlayer.zPosition = 2
        focusCurrentSoldier(currentSoldier: thisPlayer, allSoldiers: playerObjs!)
        let walkAnimation = SKAction.animate(with: thisPlayer.playerTexture.walkingTexture!, timePerFrame: 0.2)
        thisPlayer.run(SKAction.repeatForever(walkAnimation))
        
    }
    
    func playerDidMove(location: CGPoint) {
        
        guard mcm.checkPositionValid(position: location) else {
            playerFailMove()
            
            clearTilesColor()
            
            selectedSoldier = nil
            selectedName = "nothing"
            return
        }
        
        guard let thisPlayer = selectedSoldier else {
            return
        }
        thisPlayer.position.x = location.x
        thisPlayer.position.y = location.y + 30
        
    }
    
    func playerEndMove(location: CGPoint) {
        
        
        guard mcm.checkPositionValid(position: location) else {
            return
        }
        
        let targetIndexs = mcm.getIndexs(fromPostion: location)
        
        guard let thisPlayer = selectedSoldier else {
            return
        }
        
        if let i = thisPlayer.children.index(where: {$0 is SKShapeNode}) {
            let border = thisPlayer.children[i] as! SKShapeNode
            if thisPlayer.teamSide == 1 {
                border.strokeColor = .blue
            } else {
                border.strokeColor = .red
            }
            
        }
        
        guard mcm.checkTilePositionValidity(verifyTileFromTileName: mcm.getTileName(fromPosition: location)!, availableTiles: mcm.getTilesRangeAvailable(distance: (selectedSoldier?.move)!, myTileIndexs: mcm.getIndexs(fromPostion: prePosition!)!)) else {
            
            playerFailMove()
            selectedName = "nothing"
            selectedSoldier = nil
            return
        }
        
        guard isTileEmpty(targetTile: mcm.getTileName(fromPosition: location)!, playersPositionTileArray: playersPositionTileArray) else {
            playerFailMove()
            return
        }
        
        thisPlayer.position = mcm.getPosition(fromIndexs: targetIndexs!)!
        thisPlayer.tileName = mcm.getTileName(fromTileIndexs: targetIndexs!)
        thisPlayer.setScale(1)
        thisPlayer.zPosition = 1
        thisPlayer.removeAllActions()
        thisPlayer.texture = thisPlayer.playerTexture.standTexture
        
        clearTilesColor()
        focusAllSoldier(allSoldiers: playerObjs!)
        updatePlayersPositionTileArray(playerObjs: playerObjs!)
        selectedSoldier = nil
        isDidMove = true
        changeCurrentSoldierTileColor()
        
        fm.battleMenu(positionX: Int(thisPlayer.position.x), positionY: Int(thisPlayer.position.y))
        self.addChild(fm.battleMenu[0])
        self.addChild(fm.battleMenu[1])
        self.addChild(fm.battleMenu[2])
        self.addChild(fm.battleMenu[3])
        
        actionMode = 2
        actionSoldier = thisPlayer
        
    }
    
    func playerFailMove() {
        guard let thisPlayer = selectedSoldier else {
            return
        }
        
        if let i = thisPlayer.children.index(where: {$0 is SKShapeNode}) {
            let border = thisPlayer.children[i] as! SKShapeNode
            if thisPlayer.teamSide == 1 {
                border.strokeColor = .blue
            } else {
                border.strokeColor = .red
            }
            
        }
        
        thisPlayer.position = prePosition!
        thisPlayer.setScale(1)
        thisPlayer.zPosition = 1
        thisPlayer.removeAllActions()
        thisPlayer.texture = thisPlayer.playerTexture.standTexture
        selectedSoldier = nil
        
        clearTilesColor()
        changeCurrentSoldierTileColor()
        focusAllSoldier(allSoldiers: playerObjs!)
    }
    
    
    
    // MARK: -
    func isTileEmpty(targetTile: String ,playersPositionTileArray: Array<String>) -> Bool{
        if playersPositionTileArray.contains(targetTile) {
            return false
        } else {
            return true
        }
    }
    
    func isPlayer(nodeName: String) -> Bool{
        if nodeName.hasPrefix("player") {
            return true
        } else {
            return false
        }
    }
    
    
    func createTiles() {
        for col in 0...7 {
            for row in 0...5 {
                let tile = SKShapeNode(rect: CGRect(x: viewMargin + ((tileLength) * row), y: 130 + ((tileLength) * col), width: tileLength, height: tileLength))
                tile.strokeColor = SKColor.white
                tile.lineWidth = 1
                tile.fillColor = SKColor.white
                tile.fillTexture = SKTexture(imageNamed: "grassTile.png")
                tile.name = "tile" + String(row) + String(col)
                
                scene?.addChild(tile)
                
            }
        }
    }
    
    func updatePlayersPositionTileArray(playerObjs: [Player]) {
        playersPositionTileArray = []
        for player in playerObjs {
            if player.alive {
                playersPositionTileArray.append(player.tileName!)
            }
        }
    }
    
    func getPlayerMoveAbility(fromPlayerName playerName: String) -> Int{
        let player = selectPlayer(fromPlayerName: playerName)
        let movePoint = player.move
        return movePoint
    }
    
    func selectPlayer(fromId id: Int) -> Player?{
        for player in playerObjs! {
            if player.battleId == id {
                return player
            }
        }
        return nil
    }
    
    func selectPlayer(fromPlayerName name: String) -> Player{
        let index = getPlayerId(fromPlayerName: name)
        return playerObjs![index! - 1]
    }
    
    func selectPlayer(fromBattleId: Int) -> Player?{
        for player in playerObjs! {
            if player.battleId == fromBattleId {
                return player
            }
        }
        return nil
    }
    
    func selectPlayer(fromTileName tileName: String) -> Player? {
        for player in playerObjs! {
            if player.tileName == tileName {
                return player
            }
        }
        return nil
    }
    
    func selectPlayers(fromTileArray tileNames: [String]) -> [Player] {
        var players = Array<Player>()
        
        for tile in tileNames {
            for player in playerObjs! {
                if player.tileName == tile {
                    players.append(player)
                }
            }
        }
        
        return players
    }
    
    func selectNodeFromNodes(nodeName: String, fromNodes nodes: [SKNode]) -> SKNode?{
        for node in nodes {
            if (node.name?.hasPrefix(nodeName))! && node is Player {
                selectedName = node.name!
                return node
            } else {
                print("Note: No \(nodeName) found")
                return nil
            }
        }
        return nil
    }
    
    func getPlayerId(fromPlayerName name: String) -> Int?{
        let playerName = name
        let index = name.index(name.startIndex, offsetBy: 6)
        let playerId = Int(String(playerName[index]))
        return playerId!
        
    }
    
    func getPlayerObj(fromTiles tileArray: [String], playerObjs: [Player]) -> [Player]{
        
        var playerTiles = Array<Player>()
        
        for tile in tileArray {
            for player in playerObjs {
                
                if player.tileName == tile {
                    playerTiles.append(player)
                }
                
            }
        }
        
        return playerTiles
    }
    
    
    func checkPlayerData() {
        var playersPos = Array<Bool>()
        for player in playerObjs! {
            playersPos.append(player.alive)
        }
        print("Player Pos:\(playersPos)")
        print(playersPositionTileArray )
    }
    
    func isTileValidInArray (targetTile: String, availableTiles: [String]) -> Bool{
        
        for tile in availableTiles {
            if targetTile == tile {
                return true
            }
        }
        return false
    }
    
    // MARK: - Focus Function
    func focusCurrentSoldier(currentSoldier: Player, allSoldiers: [Player]) {
        for soldier in allSoldiers {
            soldier.colorBlendFactor = 0.8
            soldier.color = .gray
        }
        currentSoldier.colorBlendFactor = 0
        currentSoldier.color = .white
    }
    
    func focusAllSoldier(allSoldiers: [Player]) {
        for soldier in allSoldiers {
            soldier.colorBlendFactor = 0
        }
    }
    
    func checkSoldierAlive(allSoldier: [Player]) {
        for soldier in allSoldier {
            if soldier.alive {
                if soldier.healthPoint <= 0 {
                    soldier.alive = false
                    // Remove dead soldier's tile from playersPositionTileArray
                    let deadSoldierTile = playersPositionTileArray.index(of: soldier.tileName!)
                    playersPositionTileArray.remove(at: deadSoldierTile!)
                    
                    // Remove dead soldier from sence
                    em.dieEffect(targetSoldier: soldier)
                    
                    // Remove soldier's id from playersOrderId
                    let deadIndex = gcm.playersOrderId.index(of: soldier.battleId)
                    gcm.playersOrderId.remove(at: deadIndex!)
                    
                    
                }
            }
        }
        bi.checkSoldierAlive(playerObjs: allSoldier, solderOrderId: &gcm.playersOrderId)
        timeWating(forDuration: 1)
    }
    
    // MARK: - Change Tile Color
    func changeTilesColor(tileNames: Array<String>, toColor color: UIColor) {
        for tileName in tileNames {
            let tile = childNode(withName: tileName) as! SKShapeNode
            tile.fillColor = color
            let fadeAway = SKAction.fadeAlpha(to: 0.5, duration: 0.5)
            let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
            let actionSequence = SKAction.sequence([fadeAway, fadeIn])
            let result = SKAction.repeatForever(actionSequence)
            tile.run(result)
            
        }
    }
    
    func clearTilesColor() {
        for tileName in allTilesName {
            let tile = childNode(withName: tileName) as! SKShapeNode
            tile.alpha = 1
            tile.fillColor = .white
            tile.removeAllActions()
        }
    }
    
    func changeCurrentSoldierTileColor() {
        if let i = playerObjs?.index(where: {$0.battleId == gcm.currentSoldierActionId}) {
            let playerTileName = playerObjs?[i].tileName
            let tile = childNode(withName: playerTileName!) as! SKShapeNode
            
            if tile.fillColor != .yellow {
                changeTilesColor(tileNames: [playerTileName!], toColor: .yellow)
            }
            
            
        }
    }
    
    func selectNothing() {
        bi.resignSkillList()
    }
    
    // MARK: - Turn Function
    func turnStart() {
//        gcm.soldierTurnChange()
        changeCurrentSoldierTileColor()
        gcm.currentSoldierActionId = gcm.playersOrderId[0]
        bi.focusOrderBarIcon(fromBattleId: gcm.currentSoldierActionId)
        focusCurrentSoldier(currentSoldier: selectPlayer(fromBattleId: gcm.currentSoldierActionId)!, allSoldiers: playerObjs!)
        changeCurrentSoldierTileColor()
        
    }
    
    
    
    func turnChange() {
        
        gcm.actionPoint += 2
        if gcm.actionPoint >= 10 {
            gcm.actionPoint = 10
        }
        
//        checkSoldierAlive(allSoldier: playerObjs!)
        bi.updateActionPoint(actionPoint: gcm.actionPoint)
        
        gcm.soldierTurnChange()
        clearTilesColor()
        changeCurrentSoldierTileColor()
        bi.updateActionOrderBar(playerObjs: playerObjs!, solderOrderId: &gcm.playersOrderId)
        
        
        isDidMove = false
        actionMode = 1
        actionSoldier = nil
        
        focusCurrentSoldier(currentSoldier: selectPlayer(fromId: gcm.currentSoldierActionId)!, allSoldiers: playerObjs!)
        bi.focusOrderBarIcon(fromBattleId: gcm.currentSoldierActionId)
        
        for player in playerObjs! {
            player.visitStatusBar()
        }
        
    }
    
    func timeWating(forDuration sec: TimeInterval) {
        let wating = SKAction.wait(forDuration: sec)
        scene?.run(wating, completion: {
            self.turnChange()
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}



