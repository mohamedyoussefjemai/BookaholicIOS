//
//  BuyFormViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit
import Alamofire
class BuyFormViewController: UIViewController {
    var pricu : Int?
    var price : Int?
    var bookname : String?
    var receiver : String?
    @IBOutlet weak var negprice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func sendReq(_ sender: Any) {
        let usernameSender = UserDefaults.standard.string(forKey: "UserName")
        let p = String(price!)
        if negprice.text?.isEmpty == true {
            pricu = Int(p)
        }else{
            pricu = Int(negprice.text!)
        }
        
    //        print("book name === ",bookname!)
    //        print("sender  === ",usernameSender!)
    //        print("receiver  === ",receiver!)
    //        print("price === ",price!)
    //        print("book selected ",selectedValue!)
            let params = ["title":bookname!,
                          "titlechange":"",
                          "sender" :usernameSender! ,
                          "receiver" :receiver!,
                          "price" : String(pricu!) ,
                        "type" :"sale" ,
                        "etat" :"waiting"] as? Dictionary<String, String>
            let urlString = "http://192.168.1.4:3000/requests/add-request"
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
            AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print("req sended !")
                                    self.showToast(message: "Buy request sent!") 
                                    }
                                break
                            case .failure(let error):
                                print(error)
                            }
            }
        }
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-75, y: self.view.frame.height - 150, width: 150, height: 40))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = .systemGreen
        toastLabel.textColor = UIColor.white
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut) {
            toastLabel.alpha = 0.0
            
        } completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        }

        
    }
    
}
