//
//  calculate.swift
//  meineLocation
//
//  Created by 宋錦淳 on 2017/6/1.
//  Copyright © 2017年 Chinchun. All rights reserved.
//

import UIKit
import CoreLocation

class Calculate: UIView,CLLocationManagerDelegate {

   
    func calculateTheBattleDistance(myPositionLati:Double,myPositionLonti:Double,anotherPositionLati:Double,anotherPositionLonti:Double) -> Bool{
        
        let coordinate1 = CLLocation(latitude: myPositionLati, longitude: myPositionLonti)
        //print("我的位置:\(coordinate1)")
        let coordinate2 = CLLocation(latitude: anotherPositionLati, longitude: anotherPositionLonti)
        //print("上次的位置:\(coordinate2)")
        let distanceInMeters = coordinate2.distance(from:coordinate1)
        
        //print("戰鬥距離計算結果：\(distanceInMeters)")
        
        if(distanceInMeters <= 200){
            return true
        }else{
            return false
        }
        
    }
    
    
    func calculateTheDistance(myPositionLati:Double,myPositionLonti:Double,anotherPositionLati:Double,anotherPositionLonti:Double) -> Bool{
        
        let coordinate1 = CLLocation(latitude: myPositionLati, longitude: myPositionLonti)
        //print("我的位置:\(coordinate1)")
        let coordinate2 = CLLocation(latitude: anotherPositionLati, longitude: anotherPositionLonti)
        //print("上次的位置:\(coordinate2)")
        let distanceInMeters = coordinate2.distance(from:coordinate1)
        
        //print("計算結果：\(distanceInMeters)")
        
        if(distanceInMeters >= 200){
            return true
        }else{
            return false
        }
        
    }
    

    func pickUpTreasureTheDistance(myPositionLati:Double,myPositionLonti:Double,anotherPositionLati:Double,anotherPositionLonti:Double) -> Bool{
        
        let coordinate1 = CLLocation(latitude: myPositionLati, longitude: myPositionLonti)
        //print("我的位置:\(coordinate1)")
        let coordinate2 = CLLocation(latitude: anotherPositionLati, longitude: anotherPositionLonti)
        //print("上次的位置:\(coordinate2)")
        let distanceInMeters = coordinate2.distance(from:coordinate1)
        
        //print("計算結果：\(distanceInMeters)")
        
        if(distanceInMeters <= 50){
            return true
        }else{
            return false
        }
        
    }
    
    func nearDistanceAlert(myPositionLati:Double,myPositionLonti:Double,anotherPositionLati:Double,anotherPositionLonti:Double) -> Bool{
        
        let coordinate1 = CLLocation(latitude: myPositionLati, longitude: myPositionLonti)
        //print("我的位置:\(coordinate1)")
        let coordinate2 = CLLocation(latitude: anotherPositionLati, longitude: anotherPositionLonti)
        //print("上次的位置:\(coordinate2)")
        let distanceInMeters = coordinate2.distance(from:coordinate1)
        
        //print("計算結果：\(distanceInMeters)")
        
        if(distanceInMeters <= 50){
            return true
        }else{
            return false
        }
        
    }

    
//    func searchRequest(){
//        
//        let request = MKLocalSearchRequest()
//        
//        request.naturalLanguageQuery = "木柵派出所"
//        
//        request.region = mainMapView.region
//        let search = MKLocalSearch(request:request)
//        
//        
//        search.start { (response:MKLocalSearchResponse?, error:Error?) in
//            if error == nil && response != nil{
//                for item in response!.mapItems{
//                    self.mainMapView.addAnnotation(item.placemark)
//                }
//            }
//        }
//        
//        
//    }
    
    //    func centerMapOnLocation(location: CLLocation, map: MKMapView, radius: CLLocationDistance) {
    //        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
    //                                                                  radius * 2.0, radius * 2.0)
    //        map.setRegion(coordinateRegion, animated: true)
    //    }


    
    
}
