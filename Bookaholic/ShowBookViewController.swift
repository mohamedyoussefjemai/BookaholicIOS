//
//  ShowBookViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/14/20.
//

import UIKit
import Alamofire
class ShowBookViewController: UIViewController {

    @IBOutlet weak var btnusername: UIButton!
    @IBOutlet weak var tfPrice: UILabel!
    @IBOutlet weak var tfCateg: UILabel!
    @IBOutlet weak var tfState: UILabel!
    @IBOutlet weak var tfLang: UILabel!
    @IBOutlet weak var tfAuthor: UILabel!
    @IBOutlet weak var tfName: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var mybooksName : [String] = []
    var img : UIImage?
    var name : String?
    var author : String?
    var lang : String?
    var state : String?
    var category : String?
    var price : Int?
    var username : String?
    var userID : Int?
    var bookimage: String?
    let usernameSender = UserDefaults.standard.string(forKey: "UserName")
    let id = Int(UserDefaults.standard.string(forKey: "UserID")!)
    override func viewDidLoad() {
        super.viewDidLoad()
getmybooks()
        tfName.text = name
        tfAuthor.text = author
        tfLang.text = lang
        tfState.text = state
        tfCateg.text = category
        tfPrice.text = String(price!)+" DT"
        btnusername.setTitle(username, for: .normal)

        let url2 = URL(string: "http://192.168.1.2:3000/uploads/"+bookimage!)!
        image.loadImge(withUrl: url2)
    }
    @IBAction func showUser(){
        performSegue(withIdentifier: "showuser", sender: self)
    }
    @IBAction func showTradeForm(){
        performSegue(withIdentifier: "tradereq", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showuser"{
        let destination = segue.destination as? ShowUserViewController
        destination?.username = username
        destination?.userID = userID
        }
        if segue.identifier == "tradereq"{
            let destination = segue.destination as? TradeFormViewController
            destination?.pickerData = mybooksName
            destination?.bookname = name
            destination?.receiver = username
        }
    }
   
    @IBAction func sale (){
        
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
                                    print("jSONARRAY ===",jsonArray)
                                  
                           if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                            if list.isEmpty {
                                print("Library is empty")
                            }else{
                                for n in 0...list.count-1 {
                                    self.mybooksName.append(list[n]["title"]!! as! String)
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
}
