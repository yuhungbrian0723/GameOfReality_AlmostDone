//
//  DakaViewController.swift
//  FBlogin
//
//  Created by BrianChen on 2017/5/31.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit
import KCFloatingActionButton
import MapKit
import CoreLocation


class DakaViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var floatingBtn: KCFloatingActionButton!
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatingBtn.addItem(title: "打卡獲得屬性") {item in
            self.showNearby()
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNearby(){
        searchForAllKindOfPlaces { itemNames in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let dakaListVC = sb.instantiateViewController(withIdentifier: "dakaListVC")as!DakaListViewController
            
            print("heyy:\(itemNames.count)")
            
            dakaListVC.itemNamesss = itemNames
            self.present(dakaListVC, animated: true, completion: nil)

        }
    }
    
    
    func searchForAllKindOfPlaces(callback:@escaping ([(String,Int)])->Void){
        var itemNames = [(name:String,element:Int)]()
        let kindArray = [("cafe",1),("restaurant",1),("gym",3),("workout",3),("movie",1),("music",1),("concert",1),("activity",3)]
        var progressCounter = 1
        for kind in kindArray {
            let keyword = kind.0
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = keyword
            searchRequest.region = mapView.region
            
            let localSearch = MKLocalSearch(request: searchRequest)
            localSearch.start { (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                let mapItems = response.mapItems
                if mapItems.count > 0 {
                    for item in mapItems {
                        
                        itemNames.append((item.name!,kind.1))
                    }
                }
                if progressCounter == kindArray.count {
                    callback(itemNames)
                    
                }else{
                    progressCounter += 1
                }
            }
           
        }
        
    }
    
    
  
}










































//var itemNames = [String]()
//
//let searchRequest = MKLocalSearchRequest()
//searchRequest.naturalLanguageQuery = "cafe"
//searchRequest.region = mapView.region
//
//
//let localSearch = MKLocalSearch(request: searchRequest)
//localSearch.start { (response, error) -> Void in
//    guard let response = response else {
//        if let error = error {
//            print(error)
//        }
//        return
//    }
//    let mapItems = response.mapItems
//    var nearbyAnnotations: [MKAnnotation] = []
//    if mapItems.count > 0 {
//        for item in mapItems {
//            // 加入標註
//            itemNames.append(item.name!)
//            let annotation = MKPointAnnotation()
//            annotation.title = item.name
//            annotation.subtitle = item.phoneNumber
//            if let location = item.placemark.location {
//                annotation.coordinate = location.coordinate
//            }
//            nearbyAnnotations.append(annotation)
//        }
//    }
//    self.mapView.showAnnotations(nearbyAnnotations, animated: true)
//    let sb = UIStoryboard(name: "Main", bundle: nil)
//    let dakaListVC = sb.instantiateViewController(withIdentifier: "dakaListVC")as!DakaListViewController
//    dakaListVC.itemNamesss = itemNames
//    self.present(dakaListVC, animated: true, completion: nil)
//}
//
