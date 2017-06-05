import UIKit
import FBSDKLoginKit
import Alamofire
import M13Checkbox


enum element {
    case fire
    case water
    case wind
}

class RegisterViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var workoutM13: M13Checkbox!
    @IBOutlet weak var scienceM13: M13Checkbox!
    @IBOutlet weak var travelM13: M13Checkbox!
    @IBOutlet weak var musicM13: M13Checkbox!
    @IBOutlet weak var artM13: M13Checkbox!
    @IBOutlet weak var chestM13: M13Checkbox!
    @IBOutlet weak var ballM13: M13Checkbox!
    @IBOutlet weak var thinkingM13: M13Checkbox!
    @IBOutlet weak var movieM13: M13Checkbox!
    @IBOutlet weak var gonfuM13: M13Checkbox!
    @IBOutlet weak var socialtyM13: M13Checkbox!
    @IBOutlet weak var readingM13: M13Checkbox!
    
    
    let genders = ["請選擇","男","女"]
    let genderPickerView = UIPickerView()
    
    
    /*
     ----------------------------view------------------------
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        genderTextField.inputView = genderPickerView
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        
        
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("sadfasdf")
        genderTextField.text = genders[row]
        self.view.endEditing(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
/*
----------------------------up to server------------------------
*/
    
    
    
    
    func calculateHobbyElements(m13Box:[(M13Checkbox,element,String)]) ->(wind:Int,water:Int,fire:Int){
        var wind = 0
        var fire = 0
        var water = 0
        
        for m13item in m13Box {
            if m13item.0.checkState == .checked {
                switch m13item.1 {
                case .fire:
                    fire += 10
                case .water:
                    water += 10
                case .wind:
                    wind += 10
                }
            }
        }
        
        return (wind,water,fire)
    }

    
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
       let name = nameTextField.text
       let gender = genderTextField.text
       var genderSymbol = 0
        
        
        
        guard let nameValue = name  else {
            let alert = UIAlertController(title: "空白或錯誤欄位", message: "請填入遊戲暱稱", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard nameValue.characters.count >= 4 else {
            let alert = UIAlertController(title: "長度不足", message: "遊戲暱稱要大於四個字元", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        guard let genderValue = gender else {
            return
        }
        
        guard  genderValue == "男" || genderValue == "女" else {
            let alert = UIAlertController(title: "空白或錯誤欄位", message: "請選擇性別", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if genderValue == "男"{
            genderSymbol = 0
        }else{
            genderSymbol = 1
        }
        
        
        
        let m13Box:[(M13Checkbox,element,String)] = [(workoutM13,.fire,"健身"),(scienceM13,.water,"科學"),
                                              (travelM13,.fire,"旅行"),(musicM13,.wind,"音樂"),(artM13,.wind,"藝術"),(chestM13,.water,"棋藝"),(ballM13,.fire,"球類運動"),(thinkingM13,.water,"思考"),(movieM13,.wind,"電影"),(gonfuM13,.fire,"武術"),(socialtyM13,.wind,"社交"),(readingM13,.water,"閱讀")]
        var hobby = ""
        var countHobby = 0
        for m13Item in m13Box {
            if m13Item.0.checkState == .checked {
                if countHobby == 0 {
                    hobby.append(m13Item.2)
                }else{
                    hobby.append(",\(m13Item.2)")
                }
                countHobby += 1
            }
        }
        
        guard countHobby == 5 else {
            let alert = UIAlertController(title: "興趣欄位有誤", message: "只能填5個興趣oh！", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let elementsValue = calculateHobbyElements(m13Box: m13Box)
        let fire = elementsValue.fire
        let water = elementsValue.water
        let wind = elementsValue.wind
        
        let parameters:[String:Any] = [
            "fbid":FBSDKAccessToken.current().userID,
            "name":nameValue,
            "gender":genderSymbol,
            "wind":wind,
            "fire":fire,
            "water":water,
            "hobby":hobby,
            "vitality":100
        ]
        
        let param = ["data":parameters]
        
        let url = "http://www.gameofreality.com/MemberRegistration.php"
        Alamofire.request(url,method: .post,parameters: param).responseString { response in
            if response.result.isSuccess {
                print("OK: \(response)")
                
            }else{
                print("註冊失敗: \(String(describing: response.error))")
                return
            }
            
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = sb.instantiateViewController(withIdentifier: "mainVC")
        self.present(mainVC, animated: true, completion: nil)
  }
    
    
    
    
    
    
}
