//
//  DakaListViewController.swift
//  FBlogin
//
//  Created by BrianChen on 2017/5/31.
//  Copyright © 2017年 BrianChen. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire
import SwiftyJSON

class DakaListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var itemNamesss = [(name:String,element:Int)]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 61, width: 375, height: 547)
        tableView.delegate = self
        tableView.dataSource = self
//        let alertTest = SCLAlertView()
//        alertTest.addButton("TESTFUNC") { `
//            print("god")
//        }
//        alertTest.showInfo("First", subTitle: "try")
        
    }
   
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNamesss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = itemNamesss[indexPath.row].name
        var el:String = ""
        switch itemNamesss[indexPath.row].element {
        case 1:
             el = "風"
        case 2:
             el = "水"
        case 3:
             el = "火"
        default:
            break
        }
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = el
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = itemNamesss[indexPath.row].name
        var el:String = ""
        switch itemNamesss[indexPath.row].element {
        case 1:
            el = "風"
        case 2:
            el = "水"
        case 3:
            el = "火"
        default:
            break
        }
        let dakaAlert = SCLAlertView()
        
        dakaAlert.addButton("打卡！") {
            print("daka")
            let param = ["mid":18,"element":self.itemNamesss[indexPath.row].element]
            self.updateElement(para: param)
            
            
        }
        dakaAlert.showInfo("我在\(name)", subTitle: "打卡可以獲得\(el)屬性")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func updateElement(para:[String:Int]){
        let data = ["data":para]
        let url = "http://www.gameofreality.com/updateElement.php"
        Alamofire.request(url,method:.post,parameters: data).responseJSON { response in
            if response.result.isSuccess{
                print("OK: \(response)")
                if let json = response.result.value{
                    let jsonValue = JSON(json)
                    let memberFire = jsonValue["Messages"][0]["fire"].intValue
                    let memberWater = jsonValue["Messages"][0]["water"].intValue
                    let memberWind = jsonValue["Messages"][0]["wind"].intValue
                    self.updateTopBar(fire: memberFire, wind: memberWind, water: memberWater)
                    
                    
                }
            }else{
                print("失敗: \(String(describing: response.error))")
                return
            }
        }


    }
    
    
    func updateTopBar(fire:Int,wind:Int,water:Int)  {
        
        
    }
    
   
}
