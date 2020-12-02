//
//  ProfileViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/25/20.
//

import UIKit
import Alamofire
class ProfileViewController: UIViewController {

    @IBOutlet weak var tfUserName: UILabel!
    
    @IBOutlet weak var tfEmail: UILabel!
    
    @IBOutlet weak var tfPhone: UILabel!
    
    @IBOutlet weak var tfAddress: UILabel!
    
    var mail : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mail!)
        self.tfEmail.text = mail!
        print("----->",tfEmail.text!)
        self.profile()
    }
    
    
    @IBAction func profile(){
    let url = "http://192.168.1.4:3000/users/read-user-email/"+mail!
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
   
                    print(response)
    //to get status code
            switch response.result {
                          case .success:
                              print(response)
                              if let data = response.data {
                                  let json = String(data: data, encoding: String.Encoding.utf8)
                              
                                  print("USER ====> ",json!)
                                let data = json!.data(using: .utf8)!
                                print("data = ",data)
                                
                               
                                do {
                                   // if let jsonArray = try //JSONSerialization.jsonObject(with: data, //options : .allowFragments) as? [Dictionary<String,Any>]
                                   
                                    
                                    let jsonArray = json!
                                    print("jSONARRAY ===",jsonArray)
                                    
                                    
                                    if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                                    
                self.tfPhone.text = list[0]["phone"]!! as? String
                
                self.tfUserName.text = list[0]["username"]!! as? String
                self.tfAddress.text = list[0]["address"]!! as? String
                                       
                                       
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
    //to get JSON return value
    
    
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
    
    
    
    
    
    
    


