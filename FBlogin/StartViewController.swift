//
//  startViewController.swift
//  FBlogin
//
//  Created by BrianChen on 2017/5/17.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON



class StartViewController: UIViewController {
    var fbid :String?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBtnPressed(_ sender: Any) {
        guard FBSDKAccessToken.current()?.userID != nil else {
            print("沒有AccessToken")
            let sb = UIStoryboard(name:"Main",bundle:nil)
            let FBvc = sb.instantiateViewController(withIdentifier: "FBvc") as UIViewController
            present(FBvc, animated: true, completion: nil)
            return
        }
        print("有ACCESSTOCKEN")
        handleIfHaveAccessToken()
        //accessToken already done ,but check if this FBuserId is already exist in our server
       
        
        
       
    }
    
    func handleIfHaveAccessToken(){
        guard let fbid = FBSDKAccessToken.current()?.userID else {
            print("retard")
            return
        }

        let searchMemberURL = "http://www.gameofreality.com/searchingMember.php"
        let param = ["fbid":fbid]
        let data = ["data":param]
        Alamofire.request(searchMemberURL,method:.post,parameters: data).responseJSON { response in
            if response.result.isSuccess{
                print("OK: \(response)")
                if let json = response.result.value{
                    let jsonValue = JSON(json)
                    let name = jsonValue["Messages"][0]["name"].stringValue

                    if  name != ""{
                        let sb = UIStoryboard(name:"Main",bundle:nil)
                        let mainVC = sb.instantiateViewController(withIdentifier: "mainVC")
                        self.present(mainVC, animated: true, completion: nil)
                    }else{
                        let sb = UIStoryboard(name:"Main",bundle:nil)
                        let rgsVC = sb.instantiateViewController(withIdentifier: "rgsVC")
                        self.present(rgsVC, animated: true, completion: nil)
                    }
                }
            }else{
                print("失敗: \(String(describing: response.error))")
                return
            }
        }
        
    }

    

}
