//
//  ProfileViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/25/20.
//

import UIKit
import Alamofire
class ProfileViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate,UIPopoverControllerDelegate	 {
    
   
    var usertf : UITextField!
    
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnname: UIButton!
    @IBOutlet weak var tfTrade: UILabel!
    @IBOutlet weak var tfSale: UILabel!
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
    var filenameImage: String = ""
    var picker:UIImagePickerController?=UIImagePickerController()
    var imagePicker: UIImagePickerController!
        var   fileName2 = String();
        var url2: URL!
        enum ImageSource {
            case photoLibrary
            case camera
        }

    @IBAction func btnSelectImage(_ sender: Any) {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                           {
                               let myPickerController = UIImagePickerController()
                               myPickerController.delegate = self;
                               myPickerController.sourceType = .photoLibrary
                               self.present(myPickerController, animated: true, completion: nil)
                           }
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
             {
                 if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                     self.userImage.image = image
                    uploadImage(file : String(userID!))
                    ////
                    let headers :HTTPHeaders = ["Content-Type": "application/json"]
                let params = ["image": filenameImage] as? Dictionary<String, String>
                let urlString = "http://192.168.1.5:3000/users/update-user-image/"+String(self.userID!)
                print(String(self.userID!))
                    AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
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
                    
                    
                    
                 }else{
                     debugPrint("Something went wrong")
                 }
                 self.dismiss(animated: true, completion: nil)
             }

        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                   picker.dismiss(animated: true, completion: nil)
               }

        
        func uploadImage(file : String)
         {
             let headers: HTTPHeaders = [
                         /* "Authorization": "your_access_token",  in case you need authorization header */
                         "Content-type": "multipart/form-data"
                     ]

            
            
            
                         AF.upload(
                             multipartFormData: { multipartFormData in
                                 multipartFormData.append(self.userImage.image!.jpegData(compressionQuality: 0.5)!, withName: "upload" , fileName: file+".jpeg", mimeType: "image/jpeg")
                                
                    
                                self.filenameImage = file+".jpeg"
                                print("imaaaaaaageeeeee =====> ",self.filenameImage)
                         },
                             to: "http://192.168.1.5:3000/upload/ios", method: .post , headers: headers)
                             .response { resp in
                                 print(resp)
                         }
         }
    
    
    
    
    
    
  
       
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tabbar = tabBarController as! MyTabBar
//        mail = tabbar.mailtabar
        mail = UserDefaults.standard.string(forKey: "Email")
        userID = UserDefaults.standard.integer(forKey: "UserID")
        
        self.tfEmail.text = mail!
        self.profile()
    }
    @IBAction func menu(){
        performSegue(withIdentifier: "tomenu", sender: self)
    }
    
    @IBAction func profile(){
    let url = "http://192.168.1.5:3000/users/read-user-email/"+mail!
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
                                        let sale = list[0]["sale"]!! as? Int
                                        let trade = list[0]["trade"]!! as? Int
                                        self.tfSale.text = String(sale!)
                                        self.tfTrade.text = String(trade!)
                                        self.filenameImage = list[0]["image"]!! as? String ?? "0"
                                        
                                        if(self.filenameImage == "null")
                        {
                                            self.userImage!.image = UIImage(systemName: "person")
                        }
                                        
                                        let url2 = URL(string: "http://192.168.1.5:3000/uploads/"+self.filenameImage)!
           self.userImage.loadImge(withUrl: url2)
                                        
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
    /////////
    
    ///
    @IBAction func importImage(){

        let image = UIImagePickerController()
        image.delegate = self
        //image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        let actionSheet = UIAlertController(title: "photo Source", message: "Choose a source", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                UIImagePickerController.SourceType.camera
                self.present(image , animated: true ,completion: nil)
            }else{
                print("camera not available")
            }

        }))

        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: {(action:UIAlertAction) in
            UIImagePickerController.SourceType.photoLibrary
            self.present(image , animated: true ,completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))


        self.present(image , animated: true , completion: nil)
    }

    @IBAction func changeEmail(){
      
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
        let params = ["email":upEmail.text!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.5:3000/users/update-user-email/"+String(self.userID!)
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
        let urlString = "http://192.168.1.5:3000/users/update-user-phone/"+String(self.userID!)
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
        let urlString = "http://192.168.1.5:3000/users/update-user-address/"+String(self.userID!)
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
        UserDefaults.standard.removeObject(forKey: "UserName")
 performSegue(withIdentifier: "logout", sender: self)
//        let vc=storyboard?.instantiateViewController(identifier: "login_VC")as! LoginViewController
//        present(vc, animated: true)
    }
    
   @IBAction func goToForgotPass(){
        let vc=storyboard?.instantiateViewController(identifier: "forgot")as! ForgotPassViewController
        present(vc, animated: true)
        
    }
    

   
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func changeUsername(){


        
        
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
        let params = ["username":usertf.text!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.5:3000/users/update-user-username/"+String(self.userID!)
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print(response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    print(json!)
                                    //UserDefaults.standard.removeObject(forKey: "Username")
                                   // UserDefaults.standard.set(self.upEmail.text, forKey: "Username")
                                    self.tfUserName.text = self.usertf.text
                                   
                                    }
                               
                                 
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
           }
    
    
    @IBAction func displayAlertAction(_ sender:Any){
        let alertController = UIAlertController(title: "Change username", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: usertf)
        let okAction = UIAlertAction(title:"OK" , style:.default , handler: self.okHandler)
        let cancelAction = UIAlertAction(title:"cancel" , style:.default , handler:nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated:true)
    }
    func okHandler(alert : UIAlertAction!){
        print("hedhi l action")
        changeUsername()
    }
    func usertf(textfield: UITextField){
        usertf = textfield
        usertf?.placeholder = "tap new username"
        
    }

   
        }


extension UIImageView {
    func loadImge(withUrl url:URL) {
       DispatchQueue.global().async { [weak self] in
           if let imageData = try? Data(contentsOf: url) {
               if let image = UIImage(data: imageData) {
                   DispatchQueue.main.async {
                       self?.image = image
                   }
               }
           }
       }
   }
}

