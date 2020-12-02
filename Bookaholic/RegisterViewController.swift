//
//  RegisterViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/17/20.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController {

    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfBD: UITextField!
    @IBOutlet weak var tfName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func register(){
        let name = tfName.text
        let email = tfEmail.text
        let BD = tfBD.text
        let addr = tfAddress.text
        let phone = tfPhone.text
        let pass = tfPass.text
        let params = ["username":name,
                      "email" : email,
                    "birthdate":BD,
                      "address": addr,
                     "phone":phone,
                      "sale" : "0",
                      "trade" : "0",
                      "password" :pass] as? Dictionary<String, String>
        let urlString = "http://192.168.1.4:3000/users/add-user"
        let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
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
    
    func promptAction(promptTitle: String, promptText: String){
        
        let alert = UIAlertController(title: promptTitle, message: promptText, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    func goToLogin(){
        let vc=storyboard?.instantiateViewController(identifier: "login_VC")as!LoginViewController
        present(vc, animated: true)
        
    }
    
    
}
