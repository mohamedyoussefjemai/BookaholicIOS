//
//  RegisterViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/17/20.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController {
    var iconClick = true
    var msgid : String?
    @IBOutlet weak var eye: UIButton!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfBD: UITextField!
    @IBOutlet weak var tfName: UITextField!
    let datepicker = UIDatePicker()
    @IBOutlet weak var tfMessenger: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        eye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
      // createDatePicker()
    }
//    func createDatePicker(){
//        tfBD.textAlignment = .center
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        let donebtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//        toolbar.setItems([donebtn], animated: true)
//
//        tfBD.inputAccessoryView = toolbar
//        tfBD.inputView = datepicker
//
//        datepicker.datePickerMode = .date
//    }
//    @objc func donePressed(){
//        let formatter = DateFormatter()
//        formatter.dateStyle = .full
//        formatter.timeStyle = .full
//        tfBD.text = formatter.string(from: datepicker.date)
//        self.view.endEditing(true)
//    }
    @IBAction func register(){
        if (tfMessenger.text?.isEmpty == true){
            msgid  = "null"
        }else{
            msgid = tfMessenger.text
        }
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
                      "image": "null",
                      "messenger": msgid,
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
                                UserDefaults.standard.set(self.msgid, forKey: "Messenger")
                                self.dismiss(animated: true, completion: nil)
                                }
                  
                            break
                        case .failure(let error):
                            
                            print(error)
                        }
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
    
    
    func goToLogin(){
        let vc=storyboard?.instantiateViewController(identifier: "login_VC")as!LoginViewController
        present(vc, animated: true)
        
    }
    
    
}
