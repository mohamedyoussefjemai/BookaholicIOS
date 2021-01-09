//
//  ShowUserViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/14/20.
//

import UIKit
import Alamofire

class ShowUserViewController: UIViewController {

    @IBOutlet weak var tfAdress: UILabel!
    @IBOutlet weak var tfPhone: UILabel!
    @IBOutlet weak var tfEmail: UILabel!
    @IBOutlet weak var tfTrade: UILabel!
    @IBOutlet weak var tfSale: UILabel!
    @IBOutlet weak var tfName: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var img : UIImage?
    var name : String?
    var sale : Int?
    var trade : Int?
    var email : String?
    var phone : Int?
    var address : String?
    var username : String?
    var userID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user()
        
    }
    
    func user(){
        let url = "http://192.168.1.5:3000/users/read-user/"+String(userID!)
   let headers :HTTPHeaders = ["Content-Type": "application/json"]
       AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in print(response)
   //to get status code
           switch response.result {
                         case .success:
                             print(response)
                             if let data = response.data {
                                 let json = String(data: data, encoding: String.Encoding.utf8)
                               let data = json!.data(using: .utf8)!
                               do {
                                   let jsonArray = json!
                                   if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                                    self.name = list[0]["username"] as? String
                                    self.sale = list[0]["sale"] as? Int
                                    self.trade = list[0]["trade"] as? Int
                                    self.phone = list[0]["phone"] as? Int
                                    self.address = list[0]["address"] as? String
                                    self.email = list[0]["email"] as? String
                                    self.tfAdress.text = self.address
                                    self.tfPhone.text = String(self.phone!)
                                    self.tfEmail.text = self.email
                                    self.tfTrade.text = String(self.trade!)
                                    self.tfSale.text = String(self.sale!)
                                    self.tfName.text = self.name
                                    
                                    
                                    let  filenameImage = list[0]["image"]!! as? String ?? "0"
                                    
                                    if(filenameImage == "null")
                    {
                                        self.image!.image = UIImage(systemName: "person")
                    }
                                    
                                    let url2 = URL(string: "http://192.168.1.5:3000/uploads/"+filenameImage)!
       self.image.loadImge(withUrl: url2)
                                       }
                               } catch let error as NSError {
                                   print(error)
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
