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
                                 
                                    let jsonArray = json!
                                    print("jSONARRAY ===",jsonArray)
                                  
                                    
                                    if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                                        self.userID = list[0]["id"]!! as? Int
                                        print("userID =====>",self.userID)
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
    
   @IBAction func goToForgotPass(){
        let vc=storyboard?.instantiateViewController(identifier: "forgot")as! ForgotPassViewController
        present(vc, animated: true)
        
    }
    
    @IBAction func lib(){
       // self.library()
        //print("tableau = ",bookName)
        performSegue(withIdentifier: "pro_lib", sender: userID)
       
            

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userID = sender as! Int
        let destination = segue.destination as! LibViewController
        destination.id = userID
       
    }
    
    ///////////////////
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    @IBAction func changePass(){
     let code = randomString(length: 6)
        print(code)
       self.codeverif = code
        let params = ["to":tfEmail.text!,
                      "subject":"Change password",
                      "text":"this your code : "+code+" please write it in your phone "] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/forgot"
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
          switch response.result {
                        case .success:
                            print(response)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print(json!)
                                }
                
                            break
                        case .failure(let error):
                            
                            print(error)
                        }
        }
    
           }
    ///////
   
    
    }
    
    
    
    
    
    
    


