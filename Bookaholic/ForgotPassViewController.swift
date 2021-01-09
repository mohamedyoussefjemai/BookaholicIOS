//
//  ForgotPassViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/2/20.
//

import UIKit
import Alamofire
class ForgotPassViewController: UIViewController {

    var iconClick = true
    @IBOutlet weak var eye: UIButton!
    @IBOutlet weak var tfcode: UITextField!
    @IBOutlet weak var btnpass: UIButton!
    @IBOutlet weak var btncode: UIButton!
    @IBOutlet weak var confirmpass: UITextField!
    @IBOutlet weak var pass: UITextField!
   
    @IBOutlet weak var email: UITextField!
    
    var codeverif = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eye.isHidden = true
        self.tfcode.isHidden = true
        self.pass.isHidden = true
        self.confirmpass.isHidden = true
        self.btnpass.backgroundColor = UIColor.white
        self.btncode.backgroundColor = UIColor.white
        self.confirmpass.isSecureTextEntry = true
    }
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    @IBAction func changePass(){
     let code = randomString(length: 6)
        print(code)
       self.codeverif = code
        print(codeverif)
        print(email.text!)
        let params = ["to":email.text!,
                      "subject":"forgot password",
                      "text":"this your code : "+code+" please write it in your phone "] as? Dictionary<String, String>
        let urlString = "http://192.168.1.5:3000/users/forgot"
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON { 
        response in
          switch response.result {
                        case .success:
                            print(response)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print(json!)
                                self.tfcode.isEnabled = true
                            
                                self.btncode.backgroundColor = #colorLiteral(red: 0.9464210868, green: 0.3636219501, blue: 0.2471969128, alpha: 1)
                                self.tfcode.isHidden = false
                                self.btncode.isEnabled = true
                                self.btncode.setTitle("Verif", for: UIControl.State.normal)
                              
                                }
                
                             
                            break
                        case .failure(let error):
                            
                            print(error)
                        }
        }

           
        
               
           }
    
    @IBAction func verifCode(){

        if (self.codeverif == self.tfcode.text!){
            self.pass.isEnabled = true
            self.btnpass.isEnabled = true
            self.confirmpass.isEnabled = true
            self.pass.isHidden = false
            self.eye.isHidden = false
            self.confirmpass.isHidden = false
            self.btnpass.backgroundColor = #colorLiteral(red: 0.9464210868, green: 0.3636219501, blue: 0.2471969128, alpha: 1)
            self.btnpass.setTitle("Change Password", for: UIControl.State.normal)
        }
        else{
                goToForgotPass()
        }

           }

    @IBAction func changePassword(){
        if(pass.text! == confirmpass.text!){
            print(pass.text!)
            print("raper",email.text!)
            print("nrml",email.text)
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
            let params = ["email":email.text!,
                          "password":pass.text!] as? Dictionary<String, String>
            let urlString = "http://192.168.1.5:3000/users/update-user-email"
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print(response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print(json!)
                                    self.goTologin()
                                  
                                    }
                    
                                 
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
        }else{
           
            self.promptAction(promptTitle: "ERROR", promptText: "Confirm Password must be the same as Password ")
        }
        

           
        
               
           }
    
    
    
    func goToForgotPass(){
        let vc=storyboard?.instantiateViewController(identifier: "forgot")as! ForgotPassViewController
        present(vc, animated: true)
        
    }
    func goTologin(){
        let vc=storyboard?.instantiateViewController(identifier: "login_VC")as! LoginViewController
        present(vc, animated: true)
        
    }
    
    func promptAction(promptTitle: String, promptText: String){
        
        let alert = UIAlertController(title: promptTitle, message: promptText, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    @IBAction func btnPasswordVisiblityClicked( sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected {
            self.pass.isSecureTextEntry = false
            eye.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            self.pass.isSecureTextEntry = true
            eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func iconAction(sender: AnyObject) {
            if(iconClick == true) {
                pass.isSecureTextEntry = false
                eye.setImage(UIImage(systemName:"@eye"), for: .normal)
              } else {
                pass.isSecureTextEntry = true
                eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }

            iconClick = !iconClick
        }
}
