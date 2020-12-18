//
//  AddBookViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/8/20.
//

import UIKit
import Alamofire
class AddBookViewController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate ,UIImagePickerControllerDelegate,UIPopoverControllerDelegate{
    
    

    @IBOutlet weak var bookimage: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var labprice: UILabel!
    @IBOutlet weak var tfprice: UITextField!
    @IBOutlet weak var sell : UISwitch!
    @IBOutlet weak var tflanguage: UITextField!
    @IBOutlet weak var tfstate: UITextField!
    @IBOutlet weak var tfcategory: UITextField!
    @IBOutlet weak var tfauthor: UITextField!
    @IBOutlet weak var tftitle: UITextField!
    
    var pickerData: [String] = [String]()
    var selectedValue : String!
    var visible : Int?
    var price : Int?
    var userID: Int?

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
                    uploadImage(file : String(userID!)+"_"+tftitle.text! )

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
                             to: "http://192.168.1.6:3000/upload/ios", method: .post , headers: headers)
                             .response { resp in
                                 print(resp)
                         }
         }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = UserDefaults.standard.integer(forKey: "UserID")

        pickerData = ["romance & new adult", "adventure", "literature","comic & mangas","Personal development","Health & cooking","History","youth","social Sciences","art music & cinema","humor","police & thrillers","Religion and spirituality","school","sport & leisure","theater","tourism & travel"]
        sell.setOn(false, animated: true)
        picker.delegate = self
        picker.dataSource = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        	return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = pickerData[row]
    }
    @IBAction func addbook(){
        let title = tftitle.text
        let author = tfauthor.text
        let category = selectedValue
        let language = "arabic"
        let status = tfstate.text
        price = Int(tfprice.text ?? "0")
        let user = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let username = UserDefaults.standard.string(forKey: "UserName")
        
        let params = ["title":title!,
                      "author" : author!,
                      "price" : String(price ?? 0),
                      "category": category!,
                      "visible" : String(visible ?? 0),
                    "language" : language,
                    "status" : status!,
                    "user" : String(user!),
                    "image":self.filenameImage,
                    "username" : username!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.6:3000/books/add-book"
        let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
          switch response.result {
                        case .success:
                            print("response ==== ",response)
                            if let data = response.data {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("JSON ======= ",json!)
                                
                                self.performSegue(withIdentifier: "add_tabbar", sender: self)
                                }
                  
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
            visible = 1
            
        }else{
            tfprice.isHidden = true
            labprice.isHidden = true
            visible = 0
        }
    }
    
}
