//
//  MapCoordinateMaster.swift
//  TestGame
//
//  Created by yufan-lin on 2017/4/30.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//  Version 1.0 update on 2017/5/1

import UIKit

class MapCoordinateMaster: NSObject {
    
    var allTilesName = Array<String>()  // An array containing all tiles' name
    var mapCoorPosX = Array<Int>()  // An array containing view coordinate position in x index
    var mapCoorPosY = Array<Int>()  // An array containing view coordinate position in y index
    var tileLength = 0  // Define tile length according to device size
    var viewMargin = 0  // Define tile map's margin according to device size
    
    //  Initiate MapCoordinateMaster class using device width to get all parameters above
    init(deviceWidth: Int = 375) {
        super.init()
        
        tileLength = Int((Double(deviceWidth) * 0.96) / 6)
        viewMargin = Int((Double(deviceWidth) * 0.04) / 2)
        
        for col in 0...7 {
            mapCoorPosY.append(130 + (tileLength / 2) + ((tileLength) * col))
        }
        for row in 0...5 {
            mapCoorPosX.append(viewMargin + (tileLength / 2) + ((tileLength) * row))
        }
        
        for col in 0...7 {
            for row in 0...5 {
                allTilesName.append("tile" + String(row) + String(col))
            }
        }
        
        
    }// =========== End of init method ===========
    
    
    //  Get an array containing available tiles in a certain action such as movement range.
    func getTilesRangeAvailable(distance: Int, myTileIndexs: (indexX: Int, indexY: Int)) -> Array<String> {
        var tiles = Array<String>()
        
        for y in 0...distance{
            for x in 0...(distance - y) {
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY + y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY + y))!)
                }
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY - y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY - y))!)
                }
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY + y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY + y))!)
                }
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY - y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY - y))!)
                }
            }
        }
        
        let resultTiles = Array(Set(tiles))
        
        return resultTiles
    }
    
    func getTilesRangeAvailable(distance: Int, myTileName: String) -> Array<String>? {
        var tiles = Array<String>()
        
        guard let myTileIndexs = getTileIndexs(fromTileName: myTileName) else {
            return nil
        }
        
        for y in 0...distance{
            for x in 0...(distance - y) {
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY + y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY + y))!)
                }
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY - y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX + x, myTileIndexs.indexY - y))!)
                }
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY + y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY + y))!)
                }
                if checkTileIndexsValid(tileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY - y)) {
                    tiles.append(getTileName(fromTileIndexs: (myTileIndexs.indexX - x, myTileIndexs.indexY - y))!)
                }
            }
        }
        
        let resultTiles = Array(Set(tiles))
        
        return resultTiles
    }
    
    
    // Get the position(coordinate from view) from the tile's indexs
    func getPosition(fromIndexs indexs: (indexX: Int, indexY: Int)) -> CGPoint?{
        
        guard checkTileIndexsValid(tileIndexs: indexs) else {
            print("Wrong: The indexs is invalid")
            return nil
        }
        
        let posX = mapCoorPosX[indexs.indexX]
        let posY = mapCoorPosY[indexs.indexY]
        let posCGPoint = CGPoint(x: posX, y: posY)
        
        return posCGPoint
    }
    
    //  Get the position from the tile's name
    func getPosition(fromTileName tileName: String) -> CGPoint{
        let tileIndexs = getTileIndexs(fromTileName: tileName)
        
        return getPosition(fromIndexs: tileIndexs!)!
    }
    
    //  Get the object(any node on tile map)'s indexs from the position
    func getIndexs(fromPostion pos: CGPoint) -> (indexX: Int, indexY: Int)?{
        guard checkPositionValid(position: pos) else {
            return nil
        }
        
        let positionIndexX = (Int(pos.x) - viewMargin) / tileLength
        let positionIndexY = (Int(pos.y) - 130) / tileLength
        
        return (positionIndexX, positionIndexY)
    }
    
    func getTileName(fromPosition position: CGPoint) -> String?{
        guard checkPositionValid(position: position) else {
            return nil
        }
        let indexs = getIndexs(fromPostion: position)
        let tileName = getTileName(fromTileIndexs: indexs!)
        
        return tileName
    }
    
    //  Get the tile name from the its indexs
    func getTileName(fromTileIndexs tileIndexs: (indexX: Int, indexY: Int)) -> String?{
        guard checkTileIndexsValid(tileIndexs: tileIndexs) else {
            print("MapCoordinateMaster Wrong: The tile indexs are invalid.")
            return nil
        }
        let tileName = "tile" + String(tileIndexs.indexX) + String(tileIndexs.indexY)
        return tileName
    }
    
    //  Get the tile's indexs from its name
    func getTileIndexs(fromTileName tileName: String) -> (indexX:Int, indexY:Int)?{
        if tileName.hasPrefix("tile") {
            let XIndex = tileName.index(tileName.startIndex, offsetBy: 4)
            let Yindex = tileName.index(tileName.startIndex, offsetBy: 5)
            
            let indexX = Int(String(tileName[XIndex]))
            let indexY = Int(String(tileName[Yindex]))
            
            return (indexX!, indexY!)
        }
        
        return nil
    }
    
    // Check if a certain tile is exist based on a tile array
    func checkTilePositionValidity(verifyTileFromTileName tileName: String, availableTiles: [String]) -> Bool{
        for tile in availableTiles {
            if tileName == tile {
                return true
            }
        }
        
        return false
    }
    
    //  Check if indexs is valid indexs on 6 x 8 map
    func checkTileIndexsValid(tileIndexs indexs: (indexX: Int, indexY: Int)) -> Bool{
        if 0...5 ~= indexs.indexX && 0...7 ~= indexs.indexY {
            return true
        } else {
            return false
        }
    }
    
    // Check if the position coordinate is valid on tile map
    func checkPositionValid(position: CGPoint) -> Bool{
        if (mapCoorPosX.first! - tileLength / 2)...(mapCoorPosX.last! + tileLength / 2) ~= Int(position.x) &&
            (mapCoorPosY.first! - tileLength / 2)...(mapCoorPosY.last! + tileLength / 2) ~= Int(position.y) {
            return true
        }
        return false
    }
    
    
    
}
