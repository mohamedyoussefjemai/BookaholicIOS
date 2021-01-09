//
//  BuyFormViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit
import Alamofire
class BuyFormViewController: UIViewController {
    var price : Int?
    var bookname : String?
    var receiver : String?
    @IBOutlet weak var negprice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func sendReq(_ sender: Any) {
        let p = String(price!)
        let price = Int(negprice.text ?? p)
    //        print("book name === ",bookname!)
    //        print("sender  === ",usernameSender!)
    //        print("receiver  === ",receiver!)
    //        print("price === ",price!)
    //        print("book selected ",selectedValue!)
            let params = ["title":bookname!,
                          "sender" :usernameSender! ,
                          "receiver" :receiver!,
                          "price" :String(price ?? 0),
                        "type" :"sale" ,
                        "etat" :"waiting"] as? Dictionary<String, String>
            let urlString = "http://192.168.1.5:3000/sales/add-request"
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
            AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print("trade req sended !")
                                    }
                                break
                            case .failure(let error):
                                print(error)
                            }
            }
        }
    
    
}
