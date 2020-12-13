//
//  ProfileViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/25/20.
//

import UIKit
import Alamofire
class ProfileViewController: UIViewController {

   
    @IBOutlet weak var upAddress: UITextField!
    @IBOutlet weak var upPhone: UITextField!
    @IBOutlet weak var upEmail: UITextField!
    @IBOutlet weak var Vaddress: UIButton!
    @IBOutlet weak var Vphone: UIButton!
    @IBOutlet weak var Vemail: UIButton!
    @IBOutlet weak var tfUserName: UILabel!
    
    @IBOutlet weak var tfEmail: UILabel!
    
    @IBOutlet weak var tfPhone: UILabel!
    
    @IBOutlet weak var tfAddress: UILabel!
    
    
    var bookName:[String] = []
    var category:[String] = []
    
    var mail : String?
    var userID: Int?
    var codeverif = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tabbar = tabBarController as! MyTabBar
//        mail = tabbar.mailtabar
        mail = UserDefaults.standard.string(forKey: "Email")
        userID = UserDefaults.standard.integer(forKey: "UserID")
        
        self.tfEmail.text = mail!
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
                                 
                                    let jsonArray = json!
                                    print("jSONARRAY ===",jsonArray)
                                    if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                                       // self.userID = list[0]["id"]!! as? Int
                 let tel = list[0]["phone"]!! as? Int
                self.tfPhone.text = String(tel!)
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
    
    
    @IBAction func changeEmail(){
      
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
        let params = ["email":upEmail.text!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/update-user-email/"+String(self.userID!)
        print(String(self.userID!))
        print(tfEmail.text!)
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print(response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print(json!)
                                    UserDefaults.standard.removeObject(forKey: "Email")
                                    UserDefaults.standard.set(self.upEmail.text, forKey: "Email")
                                    self.tfEmail.text = self.upEmail.text
                                    
                                    self.upEmail.text = ""
                                   
                                    }
                    
                                 
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
           }
    
    @IBAction func changePhone(){
      
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
        let params = ["phone":upPhone.text!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/update-user-phone/"+String(self.userID!)
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print(response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print(json!)
                                    self.tfPhone.text = self.upPhone.text
                                    self.upPhone.text = ""
                                    }
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
           }
    
    
    
    @IBAction func changeAddress(){
      
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
        let params = ["address":upAddress.text!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/update-user-address/"+String(self.userID!)
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print(response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print(json!)
                                    self.tfAddress.text = self.upAddress.text
                                    self.upAddress.text = ""
                                   
                                    }
                               
                                 
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
           }
    
    
    @IBAction func goToProfile(){
        let vc=storyboard?.instantiateViewController(identifier: "profile_VC")as! ProfileViewController
        present(vc, animated: true)
      
    }
    
    @IBAction func goToLogin(){
        UserDefaults.standard.removeObject(forKey: "Email")
        UserDefaults.standard.removeObject(forKey: "Password")
        UserDefaults.standard.removeObject(forKey: "UserID")

        //performSegue(withIdentifier: "logout", sender: self)
        let vc=storyboard?.instantiateViewController(identifier: "login_VC")as! LoginViewController
        present(vc, animated: true)
    }
    
   @IBAction func goToForgotPass(){
        let vc=storyboard?.instantiateViewController(identifier: "forgot")as! ForgotPassViewController
        present(vc, animated: true)
        
    }
    
//    @IBAction func lib(){
//        performSegue(withIdentifier: "pro_lib", sender: userID)
//     
//    }
//    
//    @IBAction func post(){
//        performSegue(withIdentifier: "pro_post", sender: userID)
//          }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let userID = sender as! Int
//        if(segue.identifier == "pro_lib"){
//            let destination = segue.destination as! LibViewController
//           destination.id = userID
//        }
//        if(segue.identifier == "pro_post"){
//            let destination = segue.destination as! PostViewController
//           destination.id = userID
//        }
//     
//    }
   
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

  
   
    
    }
    
    
    
    
    
    
    


