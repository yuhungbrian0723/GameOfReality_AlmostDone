//
//  ViewController.swift
//  meineLocation
//
//  Created by 宋錦淳 on 2017/5/12.
//  Copyright © 2017年 Chinchun. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
import SwiftyJSON
import UserNotifications
import KCFloatingActionButton

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var floatingBtn: KCFloatingActionButton!
        var locationManager = CLLocationManager()
        var isLegalOfDistance = Bool()
        var isLegqlOfBattle = Bool()
        var isLegalOfPlayer = Bool()
        var isLegalOfItems = Bool()
        var nowUserlatitude = Double()
        var nowUserlontitude = Double()

        var userCorelatitude = Double()
        var userCorelontitude = Double()
        var userGender = Int()
    
        var timerMaster:Timer?
    
         var caculateMaster = Calculate()
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        floatingBtn.addItem(title: "打卡獲得屬性") {item in
            self.showNearby()
        }
        
        queryitem()
       
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.distanceFilter = 200.0
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.startUpdatingLocation()
        
        
        mainMapView.delegate = self
      
        

      
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
            searchRequest.region = mainMapView.region
            
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
   
    override func viewWillDisappear(_ animated: Bool) {
    
        timerMaster?.invalidate()
       
    }


    
    func showLocalNotificationWithMessage(){
        
        let content = UNMutableNotificationContent()
        content.title = "訊息"
        content.subtitle = "來自系統的訊息"
        content.body = "您附近有玩家！"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification2", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })

        
    }
    func showLocalNotificationWithItemMessage(){
        
        let content = UNMutableNotificationContent()
        content.title = "訊息"
        content.subtitle = "來自系統的訊息"
        content.body = "您附近有寶物！"
        content.badge = 0
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
        
        
    }

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last
        else{
                print ("Invalid currentLocation")
                return
        }
        let coordinate = currentLocation.coordinate
       print("我的緯度:\(coordinate.latitude),我的經度：\(coordinate.longitude)")
    
    nowUserlatitude = coordinate.latitude
    nowUserlontitude = coordinate.longitude
    
    queryMylastLocation()
    queryAnotherPlayerLocation()

     isLegalOfDistance = caculateMaster.calculateTheDistance(myPositionLati: nowUserlatitude, myPositionLonti: nowUserlontitude, anotherPositionLati: userCorelatitude, anotherPositionLonti: userCorelontitude)
    
    print(userlocations)
    
   
     nearInformationSearch()
   
   if(isLegalOfDistance == true){
    
        updateMyLocation(mylatitude: nowUserlatitude, mylongitude: nowUserlontitude)
        clearAnnotation()
    
    }else{
      print("少於200m,距離太近了不用上傳！")
    }
    
 
    
   DispatchQueue.once(token:"ChangeRegion"){
        
        let span = MKCoordinateSpanMake(0.015,0.015)
        let region = MKCoordinateRegionMake(coordinate,span)
        mainMapView.setRegion(region, animated: false)
    
    timerMaster = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(timerMyLocation), userInfo: nil, repeats: true)
    timerMaster?.fire()

        mainMapView.userTrackingMode = .followWithHeading
    
    }
    
    
    
    for location in userlocations {
        
        let annotation = CustomPointAnnotation()
        
        annotation.title = location["title"] as? String
        annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
        annotation.subtitle = location["subtitle"] as? String
        if let gender = location["gender"]{
            if(gender as! Int == 0){
                annotation.imageName = "wizard_stand.png"
                
            }else if(gender as! Int == 1){
                annotation.imageName = "warrior_stand.png"
            }
        }
    
        isLegqlOfBattle = caculateMaster.calculateTheBattleDistance(myPositionLati: nowUserlatitude, myPositionLonti: nowUserlontitude, anotherPositionLati: location["latitude"] as! Double, anotherPositionLonti: location["longitude"] as! Double)
   
        mainMapView.addAnnotation(annotation)
        
    }

    for iteam in iteams{
        
        let annotationIteam = itemsPointAnnotation()
        annotationIteam.title = iteam["title"] as? String
        annotationIteam.coordinate = CLLocationCoordinate2D(latitude: iteam["latitude"] as! Double, longitude: iteam["longitude"] as! Double)
        annotationIteam.subtitle = iteam["info"] as? String
        annotationIteam.imageName = iteam["image"] as? String
        
        mainMapView.addAnnotation(annotationIteam)
    }
    
}
    
    
    func timerMyLocation(){
        
    updateMyLocation(mylatitude: nowUserlatitude, mylongitude: nowUserlontitude)
    clearAnnotation()
        
        
    }
    
    
    
    
    func clearAnnotation(){
        let annotations = mainMapView.annotations
        mainMapView.removeAnnotations(annotations)

    }
    
    
    func nearInformationSearch(){
        
        
//        for i in 0..<userlocations.count{
//            
//            if let userlocationlati = userlocations[i]["latitude"]{
//             if let userlocationlong = userlocations[i]["lontitude"]{
//            
//        isLegalOfPlayer = nearDistanceAlert(myPositionLati: nowUserlatitude, myPositionLonti: nowUserlontitude, anotherPositionLati: userlocationlati as! Double, anotherPositionLonti: userlocationlong as! Double)
//                }
//            }
//        }
        
        for i in 0..<iteams.count{
            let userlocationlati = iteams[i]["latitude"] as! Double
            let userlocationlong = iteams[i]["longitude"] as! Double
           
            isLegalOfItems = caculateMaster.nearDistanceAlert(myPositionLati: nowUserlatitude, myPositionLonti: nowUserlontitude, anotherPositionLati: userlocationlati, anotherPositionLonti: userlocationlong)
              
            
        }
              if(isLegalOfPlayer == true){
            showLocalNotificationWithMessage()
        }else if(isLegalOfItems == true){
            showLocalNotificationWithItemMessage()
        }
       
    }
    
    let warriorImages = [#imageLiteral(resourceName: "warrior_step1"),#imageLiteral(resourceName: "warrior_step2")]
    let wizareImages = [#imageLiteral(resourceName: "wizard_step1"),#imageLiteral(resourceName: "wizard_step2")]
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        
        
        if annotation is MKUserLocation {
        let reuseIdentifierForMe = "my"
        let myPin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifierForMe)
        
    
        if(userGender==0){
           
            myPin.frame.size = CGSize.init(width: 60, height: 60)
            let imageview = testImgView()
            imageview.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            imageview.animationImages = wizareImages
            imageview.animationDuration = 0.5
            myPin.addSubview(imageview)
            imageview.startAnimating()
            myPin.leftCalloutAccessoryView = UIImageView(image:UIImage(named: "wizare_stand.png"))

        
        }else{
            
            myPin.frame.size = CGSize.init(width: 60, height: 60)
            let imageview = testImgView()
            imageview.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            imageview.animationImages = warriorImages
            imageview.animationDuration = 0.5
            myPin.addSubview(imageview)
            imageview.startAnimating()
            myPin.leftCalloutAccessoryView = UIImageView(image:UIImage(named: "warrior_stand.png"))
           
        }
        
        myPin.canShowCallout = true

        return myPin
        }
        if annotation is itemsPointAnnotation{
         let itemsIdentifier = "items"
         var item = mapView.dequeueReusableAnnotationView(withIdentifier: itemsIdentifier)
            if item == nil{
                item = MKAnnotationView(annotation: annotation, reuseIdentifier:itemsIdentifier)
            }else {
                item?.annotation = annotation
            }
            item?.canShowCallout = true
            
            
            let items = annotation as! itemsPointAnnotation
            item?.image = UIImage(named:items.imageName)
            item?.leftCalloutAccessoryView = UIImageView(image:UIImage(named:items.imageName))

            
            let width = 100
            let height = 50
            
            let snapshotView = UIView()
            
            let views = ["snapshotView": snapshotView]
            snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(100)]", options: [], metrics: nil, views: views))
            snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(50)]", options: [], metrics: nil, views: views))
            
            
            let label1 = UILabel(frame: CGRect(x: 0, y: -20, width: width, height: height))
            label1.text = annotation.subtitle!
            label1.numberOfLines = 0
            
            // configure button1
            let button1 = UIButton(frame: CGRect(x: 0, y: height - 25, width: width / 2 - 5, height: 25))
            button1.setTitle("拾取", for: .normal)
            button1.backgroundColor = UIColor.darkGray
            button1.layer.cornerRadius = 5
            button1.layer.borderWidth = 1
            button1.layer.borderColor = UIColor.black.cgColor
            button1.addTarget(self, action: #selector(canPickUpAlert), for: .touchDown)
            
            snapshotView.addSubview(label1)
            snapshotView.addSubview(button1)
        
            //result?.rightCalloutAccessoryView = button
            item?.detailCalloutAccessoryView = snapshotView
            
            return item
        }
        let reuseIdentifier = "anotherPlayer"
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if result == nil{
            result = MKAnnotationView(annotation: annotation, reuseIdentifier:reuseIdentifier)
        }else {
            result?.annotation = annotation
        }
    
       
        result?.canShowCallout = true
       
        let cpa = annotation as! CustomPointAnnotation
        result?.image = UIImage(named:cpa.imageName)
        result?.leftCalloutAccessoryView = UIImageView(image:UIImage(named:cpa.imageName))
        
       

    
        let width = 150
        let height = 100
        
        let snapshotView = UIView()
       
        let views = ["snapshotView": snapshotView]
        
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(150)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(100)]", options: [], metrics: nil, views: views))
        
        //let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height - 40))
        
        let label1 = UILabel(frame: CGRect(x: 0, y: -20, width: width, height: height))
        label1.text = "User Info!"
        label1.numberOfLines = 0
        
        // configure button1
        let button1 = UIButton(frame: CGRect(x: 0, y: height - 25, width: width / 2 - 5, height: 25))
        button1.setTitle("戰鬥", for: .normal)
        button1.backgroundColor = UIColor.darkGray
        button1.layer.cornerRadius = 5
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.black.cgColor
        button1.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        
        // configure button2
        let button2 = UIButton(frame: CGRect(x: width / 2 + 5, y: height - 25, width: width / 2, height: 25))
        button2.setTitle("打招呼", for: .normal)
        button2.backgroundColor = UIColor.darkGray
        button2.layer.cornerRadius = 5
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.black.cgColor
        // button2.addTarget(self, action: #selector(MainFormController.goToPosts), for: .touchDown)
    
        
       
        snapshotView.addSubview(label1)
        snapshotView.addSubview(button1)
        snapshotView.addSubview(button2)
        result?.detailCalloutAccessoryView = snapshotView
        
    
        return result
    }
    var userSelectAnnotation = "none"
    var userSelectAnnotationLatitude = Double()
    var userSelectAnnotationLongtitude = Double()
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
  
        let selectedAnnotation = view.annotation // This will give the annotation.
        userSelectAnnotation = ((selectedAnnotation?.title)!)!
        userSelectAnnotationLatitude = (selectedAnnotation?.coordinate.latitude)!
        userSelectAnnotationLongtitude = (selectedAnnotation?.coordinate.longitude)!
        
    }
    
    var isCanPickUpDistance:Bool?
    
    func canPickUpAlert(){
        
        
     isCanPickUpDistance = caculateMaster.pickUpTreasureTheDistance(myPositionLati: nowUserlatitude, myPositionLonti: nowUserlontitude, anotherPositionLati: userSelectAnnotationLatitude, anotherPositionLonti: userSelectAnnotationLongtitude)
        
        

        if(isCanPickUpDistance == true){
           

            
            let alertController = UIAlertController(title: "提示",message: "拾取完成",preferredStyle: .alert)
            
        
            let okAction = UIAlertAction(title: "確認",style: .default,handler: {
                    (action: UIAlertAction!) -> Void in
                self.userPickupTreasure(mid: 2,userSelect: self.userSelectAnnotation)
                print("拾取完成")})
            alertController.addAction(okAction)
            self.present(alertController,animated: true,completion: nil)
            
         
        }else{
            let alertController = UIAlertController(title: "提示",message: "拾取失敗，距離過遠",preferredStyle: .alert)
            
            
            let okAction = UIAlertAction(title: "確認",style: .default,handler: {
                (action: UIAlertAction!) -> Void in
                print("拾取失敗")})
            alertController.addAction(okAction)
            self.present(alertController,animated: true,completion: nil)
            
        
        
    }
        
}

    
    
    
    func userPickupTreasure(mid:Int,userSelect:String){
        
        let para = ["mid": mid,
                    "title": userSelect] as [String : Any]
        let para2:Parameters = ["data":para]
        
        let url:String = "http://www.gameofreality.com/items.php"
        Alamofire.request(url, method: .post, parameters: para2).responseString(completionHandler: { response in
            if response.result.isSuccess {
                print("觀察：拾取成功！")
            
            }else{
                print("錯誤: \(response.error)")
            }
        })
        

    }
  
    

    
    func buttonTapped(_ sender:UIButton){
        
        let alert = UIAlertController(title: nil, message: "是否展開對戰？", preferredStyle: .alert)
        
        let ok = UIAlertAction(title:"確認", style: .default){ (alert) in
            if(self.isLegqlOfBattle == true){
              let alert = UIAlertController(title: nil, message: "即將展開對戰", preferredStyle: .alert)
//              let ok = UIAlertAction(title:"確認", style: .default)
            let ok = UIAlertAction.init(title: "確認", style: .default, handler: { response in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let battleScene = sb.instantiateViewController(withIdentifier: "battleScene")
                self.present(battleScene, animated: true, completion: nil)
            })
              let cancel = UIAlertAction(title:"取消", style: .default)
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
              self.present(alert, animated: true, completion: nil)
    

            }else if(self.isLegqlOfBattle == false){
              let alert  = UIAlertController(title: nil, message: "距離太遠", preferredStyle: .alert)
                let ok = UIAlertAction(title:"確認", style: .default)
                let cancel = UIAlertAction(title:"取消", style: .default)
                alert.addAction(ok)
                alert.addAction(cancel)
              self.present(alert, animated: true, completion: nil)
                
            }
        
        }
        let cancel = UIAlertAction(title:"取消", style: .default, handler:nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
    
    
    

 
    
    
    @IBAction func useTracking(_ sender: UIButton) {
        mainMapView.userTrackingMode = .followWithHeading
    }
    
    
   
    
    func updateMyLocation(mylatitude:Double,mylongitude:Double){
        
        let para = ["member_id":2,
                    "latitude":mylatitude,
                    "longitude":mylongitude] as [String : Any]
        let para2:Parameters = ["data":para]
        

        let url:String = "http://www.gameofreality.com/db.php"
        Alamofire.request(url, method: .post, parameters: para2).responseString(completionHandler: { response in
            if response.result.isSuccess {
            print(response)

        }else{
                print("錯誤: \(response.error)")
            }
         })
}
  

    var userlocations = [["title": "New York, NY","latitude": 40.713054, "longitude": -74.007228,"subtitle": "其他玩家","mid":1,"gender":1]]
 
    func queryAnotherPlayerLocation(){

        let para2:Parameters = ["mid":2]

        let url:String = "http://www.gameofreality.com/anotherManQuery.php"
        Alamofire.request(url, method: .post, parameters: para2).responseJSON(completionHandler:  { response in
            if response.result.isSuccess {
            if let value = response.result.value {
                print(response)
            let json = JSON(value)
                if(json["Messages"].count<=0){
                    self.userlocations.removeAll()
                    
                }
                
                

                for i in 0..<json["Messages"].count{
                      let userlocations = ["title":  json["Messages"][i]["name"].stringValue,
                                           "latitude": json["Messages"][i]["latitude"].doubleValue,
                                           "longitude":json["Messages"][i]["longitude"].doubleValue,
                                           "subtitle":json["Messages"][i]["meters"].stringValue,
                                           "gender":json["Messages"][i]["gender"].intValue,
                                           "mid":json["Messages"][i]["mid"].intValue] as [String : Any]
                   
                    let allData:[String:Any] = ["mid":json["Messages"][i]["mid"].intValue]
                    
                    
                for item1 in allData{
                    //print("item1\(item1)")
                    var isSame = false

                    for var item2 in self.userlocations{
                    //print("item2\(item2)")
                  
                        if item1.key == "mid" && item1.value as! Int == item2["mid"] as! Int{
                           isSame = true
                          
                          
                            
                          item2.updateValue(json["Messages"][i]["mid"].intValue, forKey: "mid")
                          item2.updateValue(json["Messages"][i]["name"].stringValue, forKey: "title")
                          item2.updateValue(json["Messages"][i]["latitude"].doubleValue, forKey: "latitude")
                          item2.updateValue(json["Messages"][i]["longitude"].doubleValue, forKey: "longitude")
                          item2.updateValue(json["Messages"][i]["meters"].stringValue, forKey: "meters")
                          item2.updateValue(json["Messages"][i]["gender"].intValue, forKey: "gender")
                        
                        self.userlocations = []
                        self.userlocations = [item2]
                         print("updata OK!")
                        
                      //  self.userlocations.append(item2)
                      
                    }
              
                        
                    }
                    if !isSame{
                        
                         self.userlocations.append(userlocations)
                        
                    }
                    isSame = false
                    }
                  }
                }
                 }else{
                  print(response.result.error)

                 }
              //print(self.userlocations)
             })
        
         }

        


    
    
    
    var mylocations = [["title": "New York, NY","latitude": 40.713054, "longitude": -74.007228,"subtitle": "其他玩家"]]
    
    func queryMylastLocation(){
        let para2:Parameters = ["member_id":2]
        let url:String = "http://www.gameofreality.com/query_db.php"
        Alamofire.request(url, method: .post, parameters: para2).responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                   self.mylocations = [["title": json["name"].stringValue,"latitude": json["latitude"].doubleValue, "longitude": json["longitude"].doubleValue,"subtitle": "是我","gender":json["gender"].intValue]]
                   self.userCorelatitude = json["latitude"].doubleValue
                   self.userCorelontitude = json["longitude"].doubleValue
                   self.userGender = json["gender"].intValue
                  // print("查詢我的位置:\(self.userCorelatitude),\(self.userCorelontitude)")
                }else{
                    print(response.result.error)
                    
                }
            }
        })
    }
    
    
    var iteams = [["t_id": 0,"title": "","info": "","image": "","latitude": 40.713054,"longitude": -74.007228]]
    func queryitem(){
        let url:String = "http://www.gameofreality.com/items.php"
        Alamofire.request(url).responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in 0..<json.count{
                    let iteam = ["t_id":json[i]["t_id"].intValue,
                                    "title":json[i]["t_name"].stringValue,
                                    "info":json[i]["t_info"].stringValue,
                                    "image":json[i]["t_image"].stringValue,
                                    "latitude":json[i]["t_latitude"].doubleValue,
                                    "longitude":json[i]["t_longitude"].doubleValue] as [String:Any]
                    
                    let allData:[String:Any] = ["t_id":json[i]["t_id"].intValue]
                        
                    for item1 in allData{
                            //print("item1\(item1)")
                    var isSame = false
                            
                    for var item2 in self.iteams{
                                //print("item2\(item2)")
                                
                        if item1.key == "t_id" && item1.value as! Int == item2["t_id"] as! Int{
                        isSame = true
                            
                        self.iteams = [item2]
                        
                        //print("updata OK!")
                        }
                        }

                        if !isSame{
                            self.iteams.append(iteam)
                            print(self.iteams)
                            }
                            isSame = false
                        }
                    }
                    
                }
                    
            }else{
                print(response.result.error)
                    
            }
        })
    }
    
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DispatchQueue{
    private static var _onceTokens = [String]()
    class func once(token:String,job:(Void)->Void){
              objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        
        if _onceTokens.contains(token){
            return
        }
              _onceTokens.append(token)
        job()
        
    }
}



class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}
class itemsPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class testImgView : UIImageView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false

    }
}
