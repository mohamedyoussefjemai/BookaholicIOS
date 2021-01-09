//
//  UpDateBookViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/9/20.
//

import UIKit
import Alamofire
class UpDateBookViewController: UIViewController ,UINavigationControllerDelegate ,UIImagePickerControllerDelegate,UIPopoverControllerDelegate{

    @IBOutlet weak var bookimage: UIImageView!
    @IBOutlet var updateView: UIView!
    @IBOutlet weak var tfprice: UITextField!
    @IBOutlet weak var labprice: UILabel!
    @IBOutlet weak var sell: UISwitch!
    @IBOutlet weak var tflanguage: UITextField!
    @IBOutlet weak var tfstatus: UITextField!
    @IBOutlet weak var tfcategory: UITextField!
    @IBOutlet weak var tfauthor: UITextField!
    @IBOutlet weak var tftitle: UITextField!
    
    var userID: Int?

    var bookname: String?
    var auth: String?
    var cat: String?
    var stat: String?
    var lang: String?
    var prix : Int?
    var vis : Int?
    var book_id : Int?
    
    var price : Int?
    var image : String?
    
    
    
    var filenameImage: String = ""
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
                     self.bookimage.image = image
                    uploadImage(file : String(userID!)+"_"+self.randomString(length: 16) )

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
                                 multipartFormData.append(self.bookimage.image!.jpegData(compressionQuality: 0.5)!, withName: "upload" , fileName: file+".jpeg", mimeType: "image/jpeg")
                                
                    
                                self.filenameImage = file+".jpeg"
                                print("imaaaaaaageeeeee =====> ",self.filenameImage)
                         },
                             to: "http://192.168.1.5:3000/upload/ios", method: .post , headers: headers)
                             .response { resp in
                                 print(resp)
                         }
         }
    
    
    
    override func viewDidLoad() {
        
        userID = UserDefaults.standard.integer(forKey: "UserID")
        super.viewDidLoad()
        tftitle.text = bookname
        tfauthor.text = auth
        tfcategory.text = cat
        tfstatus.text = stat
        tflanguage.text = lang
        tfprice.text = String(prix!)
        if(tfprice.text != "0"){
            tfprice.isHidden = false
            labprice.isHidden = false
            
            sell.setOn(true, animated: true)
        }else{
            sell.setOn(false, animated: true)
            
        }
        let url2 = URL(string: "http://192.168.1.5:3000/uploads/"+image!)!
self.bookimage.lodImage(withUrl: url2)
    }
    
    @IBAction func update(){
        let user = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let username = UserDefaults.standard.string(forKey: "UserName")
        let title = tftitle.text
        
        let author = tfauthor.text
       
        let category = tfcategory.text
        
        let status = tfstatus.text
        
        let language = tflanguage.text
        
        let price = Int(tfprice.text!)
       print("visible = ",vis!)
        let params = ["title": title!,
                      "author" : author!,
                      "price" : String(price!),
                      "category": category!,
                      "visible" : String(vis!),
                    "language" : language!,
                    "status" : status!,
                    "user" : String(user!),
                    "image":self.filenameImage,
                    "username" : username!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.5:3000/books/update-book/"+String(book_id!)
        let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
          switch response.result {
                        case .success:
                            print("response ==== ",response)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                               // self.dismiss(animated: false, completion: nil)
                                self.performSegue(withIdentifier: "uptohome", sender: self)                              }
                  
                            break
                        case .failure(let error):
                            
                            print(error)
                        }
        }


}
    @IBAction func showPrice()  {
        if sell.isOn{
            tfprice.isHidden = false
            labprice.isHidden = false
            vis = 1
            
        }else{
            tfprice.isHidden = true
            labprice.isHidden = true
            vis = 0
        }
    }
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension UIImageView {
    func lodImage(withUrl url:URL) {
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


