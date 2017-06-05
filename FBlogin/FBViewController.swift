//
//  ViewController.swift
//  FBlogin
//
//  Created by BrianChen on 2017/5/8.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class FBViewController: UIViewController ,FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var faceBookLogIn: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faceBookLogIn.readPermissions = ["public_profile", "email", "user_friends"]
        faceBookLogIn.delegate = self
        
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard error == nil else {
            print("login FB error")
            return
        }
        print("手動成功登入")
        if FBSDKAccessToken.current() != nil {
            handleIfHaveAccessToken()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    @IBAction func facebookLogOut(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func handleIfHaveAccessToken(){
        let searchMemberURL = "http://www.gameofreality.com/searchingMember.php"
        let param = ["fbid":FBSDKAccessToken.current().userID]
        let data = ["data":param]
        Alamofire.request(searchMemberURL,method:.post,parameters: data).responseJSON { response in
            if response.result.isSuccess{
                print("OK: \(response)")
                if let json = response.result.value{
                    let jsonValue = JSON(json)
                    if let member = jsonValue["Messages"][0].dictionary{
                        print(member)
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
                print("註冊失敗: \(String(describing: response.error))")
                return
            }
        }
        
    }


}

















//func fetchProfile(){
//    print("fetch profile")
//    //        let userDefaults = UserDefaults.standard
//    //        userDefaults.set(FBSDKAccessToken.current().userID, forKey: "fbUserId")
//    //        userDefaults.synchronize()
//    //        print(FBSDKAccessToken.current().userID)
//    //        print("------------")
//    
//    let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
//    
//    FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {
//        connection, result, error -> Void in
//        
//        if error != nil {
//            print("longinerror =\(error)")
//        } else {
//            
//            if let resultNew = result as? [String:Any]{
//                
//                //                  let email = resultNew["email"]  as! String
//                //                  print(email)
//                
//                let firstName = resultNew["first_name"] as! String
//                print(firstName)
//                
//                let lastName = resultNew["last_name"] as! String
//                print(lastName)
//                
//                if let picture = resultNew["picture"] as? NSDictionary,
//                    let data = picture["data"] as? NSDictionary,
//                    let url = data["url"] as? String {
//                    print(url) //臉書大頭貼的url, 再放入imageView內秀出來
//                }
//            }
//        }
//    })
//}


