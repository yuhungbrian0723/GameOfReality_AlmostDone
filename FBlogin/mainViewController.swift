import UIKit
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class mainViewController: UIViewController {
    @IBOutlet weak var topBarCV: UIView!
    @IBOutlet weak var meCV: UIView!
    @IBOutlet weak var mapCV: UIView!
    @IBOutlet weak var itemCV: UIView!
    var mid:Int?
    var fire:Int?
    var wind:Int?
    var water:Int?
    var name:String?
    var hobby:String?
    
    var topBarViewCotroller:TopBarViewController!
    var meViewController:MeViewController!
    var mapViewController:ViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meCV.isHidden = true
        itemCV.isHidden = true
        
        for vc in childViewControllers {
            if vc is TopBarViewController {
                topBarViewCotroller = vc as! TopBarViewController
            }else if vc is MeViewController{
                meViewController = vc as!MeViewController
            }
        }
        
        guard let fbid = FBSDKAccessToken.current()?.userID else {
            return
        }
        let center = ServerCenter()
        center.getMemberInfo(fbid:fbid) { (isOK) in
            if isOK {
                self.mid = center.memberId
                self.fire = center.memberFire
                self.wind = center.memberWind
                self.water = center.memberWater
                self.name = center.memberName
                self.hobby = center.memberHobby
                self.setTopBarContent()
                self.setMeTabValue()
                
                let defaultCenter = UserDefaults.standard
                let nowMid = defaultCenter.integer(forKey: "mid")
                if self.mid != nowMid{
                    print("YESYESYESYES")
                    defaultCenter.set(self.mid, forKey: "mid")
                }
            }else{
                print("wronggggggggggggg")
            }
        }
        
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    func setTopBarContent(){
        if let name = name {
            topBarViewCotroller.nameLabel.text = name
        }
        
        if let wind = wind,let fire = fire,let water = water {
            topBarViewCotroller.fireLabel.text = String(fire)
            topBarViewCotroller.windLabel.text = String(wind)
            topBarViewCotroller.waterLabel.text = String(water)
        }
        
        
    }
    
    func setMeTabValue(){
        if let name = name {
            meViewController.nameLabel.text = name
        }
        
        if let wind = wind,let fire = fire,let water = water ,let hobby = hobby{
            meViewController.fireLabel.text = String(fire)
            meViewController.windLabel.text = String(wind)
            meViewController.waterLabel.text = String(water)
            meViewController.hobbyLabel.text = String(hobby)
        }
        

    }
    
    @IBAction func meTabPressed(_ sender: Any) {
        mapCV.isHidden = true
        meCV.isHidden = false
        itemCV.isHidden = true
    }
    
    @IBAction func mapTabPressed(_ sender: Any) {
        mapCV.isHidden = false
        meCV.isHidden = true
        itemCV.isHidden = true
    }
    
    @IBAction func itemTabPressed(_ sender: Any) {
        mapCV.isHidden = true
        meCV.isHidden = true
        itemCV.isHidden = false
    }
    
    
    
}
//"1027880014022210"
