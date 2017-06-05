//
//  itemsViewController.swift
//  meineLocation
//
//  Created by 宋錦淳 on 2017/6/2.
//  Copyright © 2017年 Chinchun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class itemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
@IBOutlet var collectionView: UICollectionView!
    

    @IBOutlet weak var textLabel: UILabel!
    private var iteams = Array<Dictionary<String, Any>>()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      queryItem()
   
      
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! itemsCollectionViewCell
      
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.imageView.image = UIImage(named: itemsImages[indexPath.row])
        print(itemsImages)
  
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        for i in 0..<iteams.count{
            var index = indexPath.item
  
            if(index == i){
                let iteamInfo = iteams[i]["info"] as? String
                textLabel.text = iteamInfo
                
                }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    @IBAction func useBtn(_ sender: Any) {
        
        
    }
    
    
    
    
    @IBAction func useDeleteBtn(_ sender: Any) {
        
    }
  
   
    
    
    
    var itemsImages = Array<String>()
    func queryItem(){
        let url:String = "http://www.gameofreality.com/itemSearch.php"
        let para2:Parameters = ["mid":2]
        Alamofire.request(url, method: .post, parameters: para2).responseJSON(completionHandler: { response in
            if response.result.isSuccess {
                print(response.description)
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in 0..<json["Messages"].count{
                        let iteam = ["t_id":json["Messages"][i]["t_id"].intValue,
                                     "title":json["Messages"][i]["t_name"].stringValue,
                                     "info":json["Messages"][i]["t_info"].stringValue,
                                     "image":json["Messages"][i]["t_image"].stringValue] as [String:Any]
                        
                    let itemImage = json["Messages"][i]["t_image"].stringValue
                    
                        
                  
//                        let allData:[String:Any] = ["t_id":json["Messages"][i]["t_id"].intValue]
//
                        
//                        for item1 in allData{
//                            //print("item1\(item1)")
//                            var isSame = false
//                            
//                            for var item2 in self.iteams{
//                                //print("item2\(item2)")
//                                
//                                if item1.key == "t_id" && item1.value as! Int == item2["t_id"] as! Int{
//                                    isSame = true
//                                    
                        
//                                    //print("updata OK!")
//                                }
//                            }
//                            
//                            if !isSame{
                                self.iteams.append(iteam)
                                print(self.iteams)
                                self.itemsImages.append(itemImage)
                        
//                                print(self.iteams)
//                            }
//                            isSame = false
//                        }
                    }
                     print(self.itemsImages.count)
                    self.collectionView.reloadData()
                }
                
            }else{
                print(response.result.error)
                
            }
            
        })
        
     
    }

    
    
    

}
