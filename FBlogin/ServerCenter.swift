//
//  ServerCenter.swift
//  FBlogin
//
//  Created by BrianChen on 2017/5/29.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ServerCenter: NSObject {
    var memberId:Int?
    var memberName:String?
    var memberGender:Int?
    var memberHobby:String?
    var memberFire:Int?
    var memberWater:Int?
    var memberWind:Int?
    var memberVitality:Int?
    
    
    
    func getMemberInfo(fbid:String,callBack:@escaping (Bool)->Void){
        
        let searchMemberURL = "http://www.gameofreality.com/searchingMember.php"
        let param = ["fbid":fbid]
        let data = ["data":param]
        
        Alamofire.request(searchMemberURL,method:.post,parameters: data).responseJSON { response in
            if response.result.isSuccess{
                print("OK: \(response)")
                if let json = response.result.value{
                    let jsonValue = JSON(json)
                    self.memberId = jsonValue["Messages"][0]["mid"].intValue
                    self.memberName = jsonValue["Messages"][0]["name"].stringValue
                    self.memberGender = jsonValue["Messages"][0]["gender"].intValue
                    self.memberHobby = jsonValue["Messages"][0]["hobby"].stringValue
                    self.memberFire = jsonValue["Messages"][0]["fire"].intValue
                    self.memberWater = jsonValue["Messages"][0]["water"].intValue
                    self.memberWind = jsonValue["Messages"][0]["wind"].intValue
                    self.memberVitality = jsonValue["Messages"][0]["vitality"].intValue
                    
                    if self.memberId != nil {
                        callBack(true)
                    }else{
                        callBack(false)
                    }
                }
            }else{
                print("失敗: \(String(describing: response.error))")
                return
            }
        }

        
    }
    
    
    
    
    
    func isMemberExist(fbid:String,callBack:@escaping (Bool)->Void){
        
        let searchMemberURL = "http://www.gameofreality.com/searchingMember.php"
        let param = ["fbid":fbid]
        let data = ["data":param]
        Alamofire.request(searchMemberURL,method:.post,parameters: data).responseJSON { response in
            if response.result.isSuccess{
                print("OK: \(response)")
                if let json = response.result.value{
                    let jsonValue = JSON(json)
                    self.memberName = jsonValue["Messages"][0]["name"].stringValue
                    self.memberGender = jsonValue["Messages"][0]["gender"].intValue
                    self.memberHobby = jsonValue["Messages"][0]["hobby"].stringValue
                    self.memberFire = jsonValue["Messages"][0]["fire"].intValue
                    self.memberWater = jsonValue["Messages"][0]["water"].intValue
                    self.memberWind = jsonValue["Messages"][0]["wind"].intValue
                    self.memberVitality = jsonValue["Messages"][0]["vitality"].intValue
                    
                    if self.memberName != nil {
                        callBack(true)
                    }else{
                        callBack(false)
                    }
                }
            }else{
                print("失敗: \(String(describing: response.error))")
                return
            }
        }
        
        
    }

    
    
    
}








//if let member = jsonValue["Messages"][0].dictionary{
//    
//    if let name = member["name"]?.string
//    {
//        self.memberName = name
//    }
//    
//    
//    self.memberGender = member["gender"]?.intValue
//    self.memberHobby = member["hobby"]?.stringValue
//    self.memberFire = member["fire"]?.intValue
//    self.memberWater = member["water"]?.intValue
//    self.memberWind = member["Wind"]?.intValue
//    self.memberVitality = member["vitality"]?.intValue
//    
//    
//}
