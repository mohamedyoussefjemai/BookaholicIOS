//
//  TradeFormViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit
import Alamofire
class TradeFormViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var price : Int?
    var pickerData : [String]?
    var selectedValue : String!
    let usernameSender = UserDefaults.standard.string(forKey: "UserName")
    @IBOutlet weak var bookpicker: UIPickerView!
    var bookname : String?
    var receiver : String?
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var TFprice: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switcher.setOn(false, animated: true)
        bookpicker.delegate = self
        bookpicker.dataSource = self
    }
   

    @IBAction func showPrice()  {
        if switcher.isOn{
            TFprice.isHidden = false
        }else{
            TFprice.isHidden = true
        }
    }
    @IBAction func trade (){
        let price = Int(TFprice.text ?? "0")
        print("book name === ",bookname!)
        print("sender  === ",usernameSender!)
        print("receiver  === ",receiver!)
        print("price === ",price!)
        print("book selected ",selectedValue!)
        
        let params = ["title":bookname!,
                      "sender" :usernameSender! ,
                      "receiver" :receiver!,
                      "titlechange": selectedValue!,
                      "price" :price!,
                    "type" :"trade" ,
                    "etat" :"waiting"] as? Dictionary<String, String>
        
        let urlString = "http://192.168.1.2:3000/requests/add-request"
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
    func getmybooks(){
        let id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.2:3000/books/lib-book/"+String(id!)
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
                          case .success:
                              print(response)
                              if let data = response.data {
                                  let json = String(data: data, encoding: String.Encoding.utf8)
                                let data = json!.data(using: .utf8)!
                               do {
                                   let jsonArray = json!
                           if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                            if list.isEmpty {
                                print("Library is empty")
                            }else{
                                for n in 0...list.count-1 {
                                    self.pickerData!.append(list[n]["title"]!! as! String)
                                }
                            }
                           }
                                }
                                  }
                              break
                          case .failure(let error):
                              print(error)
                          }
          }
    }
    func convertToDictionary(text: String) -> Any? {

         if let data = text.data(using: .utf8) {
             do {
                 return try JSONSerialization.jsonObject(with: data, options: []) as? Any
             } catch {
                 print(error.localizedDescription)
             }
         }
         return nil
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData![row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = pickerData![row]
    }
}