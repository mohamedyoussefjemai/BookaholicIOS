//
//  LoginViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/11/20.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController,UITextFieldDelegate{
    
    
    
   
    
    
    @IBAction func Forgot(_ sender: Any) {
        goToForgotPass()
    }
    
    @IBOutlet weak var eye: UIButton!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    var id : Int?
    var username : String?
    var mail : String?
    var iconClick = true
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        self.tfEmail.delegate = self
                self.tfPass.delegate = self
//        UserDefaults.standard.removeObject(forKey: "Email")
//        UserDefaults.standard.removeObject(forKey: "Password")
//        UserDefaults.standard.removeObject(forKey: "UserID")
//        
    }
    override func viewWillAppear(_ animated: Bool) {
        let Email = defaults.string(forKey: "Email")
        let Password = defaults.string(forKey: "Password")
        if (Email == nil && Password == nil){
            print("fama chay")
        }
        else{
            print("jawek behi")
            performSegue(withIdentifier: "tabar", sender: self)
        }
        print("Email = ",Email ?? "empty")
        print("password = ",Password ?? "empty")
        print("ID = ",defaults.string(forKey: "UserID") ?? "empty")
    }
  
    
    @IBAction func login(){
       
//        UserDefaults.standard.set(tfEmail.text, forKey: "Email")
//        UserDefaults.standard.set(tfPass, forKey: "Password")
//        
        let params = ["email":tfEmail.text,
                      "password":tfPass.text] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/login"
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON { [self]
        response in
          switch response.result {
                        case .success:
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                if(json! == "true"){
                                    self.user()
                                    UserDefaults.standard.set(tfEmail.text, forKey: "Email")
                                    UserDefaults.standard.set(tfPass.text, forKey: "Password")
                                     //mail = tfEmail.text
                                   performSegue(withIdentifier: "tabar", sender: self)
                                }else
                                {
                                    self.promptAction(promptTitle: "ERROR", promptText: "something went wrong ")

                                }
                                }
                            break
                        case .failure(let error):
                            
                            print(error)
                        }
           // print("oulalalalalalalal "+String(id!))
            
            
            
        }

        
        
               
           }
    
        @IBAction func btnPasswordVisiblityClicked( sender: Any) {
            (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
            if (sender as! UIButton).isSelected {
                self.tfPass.isSecureTextEntry = false
                eye.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                self.tfPass.isSecureTextEntry = true
                eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        }
    
    
    
    @IBAction func iconAction(sender: AnyObject) {
            if(iconClick == true) {
                tfPass.isSecureTextEntry = false
                eye.setImage(UIImage(systemName:"@eye"), for: .normal)
              } else {
                tfPass.isSecureTextEntry = true
                eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }

            iconClick = !iconClick
        }
    
    
    func promptAction(promptTitle: String, promptText: String){
        
        let alert = UIAlertController(title: promptTitle, message: promptText, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    

   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let mail = sender as! String
//        let id = sender as! Int
        if segue.identifier == "tabar"{
            let destination = segue.destination as? MyTabBar
            destination?.mailtabar = mail
           destination?.userID = id
        destination?.username = username
        }
        
          
            
       
    }
    func goToForgotPass(){
//        let vc=storyboard?.instantiateViewController(identifier: "forgot")as! ForgotPassViewController
//        present(vc, animated: true)
        performSegue(withIdentifier: "forgot", sender: self)
    }
    @IBAction func goToRegister(){
        let vc=storyboard?.instantiateViewController(identifier: "register")as! RegisterViewController
        present(vc, animated: true)
        
    }
    
   
     func user(){
        let url = "http://192.168.1.4:3000/users/read-user-email/"+tfEmail.text!
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
                                        self.id = list[0]["id"] as? Int
                                        UserDefaults.standard.set(self.id, forKey: "UserID")
                                        self.username = list[0]["username"] as? String
                                        UserDefaults.standard.set(self.username, forKey: "UserName")
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
    
    

