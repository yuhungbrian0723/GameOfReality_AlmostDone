//
//  TileRangeMaker.swift
//  TestGame
//
//  Created by yufan-lin on 2017/5/10.
//  Copyright © 2017年 yufan-lin. All rights reserved.
//

import UIKit

class TileRangeMaker: NSObject {
    // MARK: Warrior skills' tile range
    func coverRange(selfTile: String) -> [String]{
        let selfIndexs = getTileIndexs(fromTileName: selfTile)
        let range = getTilesRangeAvailable(distance: 2, myTileIndexs: selfIndexs!)
        
        return range
    }
    
    // MARK: Wizard skills' tile range
    func enegyImpactRange(selfTile: String) -> [String] {
        var range = Array<String>()
        let selfIndexs = getTileIndexs(fromTileName: selfTile)
        range = getTilesRangeAvailable(distance: 3, myTileIndexs: selfIndexs!)
        
        return range
    }
    
    func fireExplosionRange(selfTile: String) -> [String] {
        var range = Array<String>()
        let selfIndexs = getTileIndexs(fromTileName: selfTile)
        range = getTilesRangeAvailable(distance: 3, myTileIndexs: selfIndexs!)
        
        return range
    }
    
    func windSplitterRange(selfTile: String) -> [String] {
        var range = Array<String>()
        let selfIndexX = getTileIndexs(fromTileName: selfTile)?.indexX
        let selfIndexY = getTileIndexs(fromTileName: selfTile)?.indexY
        
        if selfIndexX == 0 {
            for i in 1...5 {
                range.append(getTileName(fromTileIndexs: (i, selfIndexY!))!)
            }
            
        } else if selfIndexX == 5 {
            for i in 0...4 {
                range.append(getTileName(fromTileIndexs: (i, selfIndexY!))!)
            }
            
        } else {
            for i in 0..<selfIndexX! {
                range.append(getTileName(fromTileIndexs: (i, selfIndexY!))!)
            }
            for i in (selfIndexX!+1)...5 {
                range.append(getTileName(fromTileIndexs: (i, selfIndexY!))!)
            }
            
        }
        
        if selfIndexY == 0 {
            for i in 1...7 {
                range.append(getTileName(fromTileIndexs: (selfIndexX!, i))!)
            }
            
        } else if selfIndexY == 7 {
            for i in 0...6 {
                range.append(getTileName(fromTileIndexs: (selfIndexX!, i))!)
            }
            
        } else {
            for i in 0..<selfIndexY! {
                range.append(getTileName(fromTileIndexs: (selfIndexX!, i))!)
            }
            for i in (selfIndexY!+1)...7 {
                range.append(getTileName(fromTileIndexs: (selfIndexX!, i))!)
            }
            
        }
        
        return range
    }
    
    func waterCrystalRange(selfTile: String) -> [String] {
        var range = Array<String>()
        let selfIndexs = getTileIndexs(fromTileName: selfTile)
        range = getSquareTilesRange(distance: 1, myTileIndexs: selfIndexs!)
        
        let repeatIndexs = range.index(of: selfTile)
        range.remove(at: repeatIndexs!)
        
        return range
    }
    
    func GravityFieldRange(selfTile: String) -> [String] {
        var range = Array<String>()
        let selfIndexs = getTileIndexs(fromTileName: selfTile)
        range = getTilesRangeAvailable(distance: 4, myTileIndexs: selfIndexs!)
        
        return range
    }

    
    // MARK: Private Methods ==================================================================================
    private func getTilesRangeAvailable(distance: Int, myTileIndexs: (indexX: Int, indexY: Int)) -> Array<String> {
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
    
    private func getSquareTilesRange(distance: Int, myTileIndexs: (indexX: Int, indexY: Int)) -> Array<String> {
        var tiles = Array<String>()
        
        for y in 0...distance{
            for x in 0...(distance) {
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
    
    
    
    //  Get the tile name from the its indexs
    private func getTileName(fromTileIndexs tileIndexs: (indexX: Int, indexY: Int)) -> String?{
        guard checkTileIndexsValid(tileIndexs: tileIndexs) else {
            print("MapCoordinateMaster Wrong: The tile indexs are invalid.")
            return nil
        }
        let tileName = "tile" + String(tileIndexs.indexX) + String(tileIndexs.indexY)
        return tileName
    }
    
    //  Get the tile's indexs from its name
    private func getTileIndexs(fromTileName tileName: String) -> (indexX:Int, indexY:Int)?{
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
    private func checkTilePositionValidity(verifyTileFromTileName tileName: String, availableTiles: [String]) -> Bool{
        for tile in availableTiles {
            if tileName == tile {
                return true
            }
        }
        
        return false
    }
    
    //  Check if indexs is valid indexs on 6 x 8 map
    private func checkTileIndexsValid(tileIndexs indexs: (indexX: Int, indexY: Int)) -> Bool{
        if 0...5 ~= indexs.indexX && 0...7 ~= indexs.indexY {
            return true
        } else {
            return false
        }
    }
    
    
}
