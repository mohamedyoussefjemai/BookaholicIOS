//
//  LoginViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/11/20.
//

import UIKit
import Alamofire
class LoginViewController: UIViewController{
    
    
    
   
    
    
    @IBAction func Forgot(_ sender: Any) {
        goToForgotPass()
    }
    
    @IBOutlet weak var eye: UIButton!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    
    var iconClick = true
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
       
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

    

    
    @IBAction func login(){
     
        let params = ["email":tfEmail.text,
                      "password":tfPass.text] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/login"
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON { [self]
        response in
          switch response.result {
                        case .success:
                            print(response)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                if(json! == "true"){
                                    //self.promptAction(promptTitle: "SUCCESSFUL", promptText: "logged in")
                                let mail = tfEmail.text
                            performSegue(withIdentifier: "logprof", sender: mail)
                                   
                                }else
                                {
                                    self.promptAction(promptTitle: "ERROR", promptText: "something went wrong ")
                                
                                }
                                }
                
                             
                            break
                        case .failure(let error):
                            
                            print(error)
                        }
        }

           
        
               
           }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mail = sender as! String
        let destination = segue.destination as! ProfileViewController
        destination.mail = mail
    }
    func goToForgotPass(){
        let vc=storyboard?.instantiateViewController(identifier: "forgot")as! ForgotPassViewController
        present(vc, animated: true)
        
    }
    @IBAction func goToRegister(){
        let vc=storyboard?.instantiateViewController(identifier: "register")as! RegisterViewController
        present(vc, animated: true)
        
    }
    }
    
    

