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
    
    @IBOutlet weak var langPicker: UIPickerView!
    @IBOutlet weak var statePicker: UIPickerView!
    var pickerData = ["Please select a category","romance & new adult", "adventure", "literature","comic & mangas","Personal development","Health & cooking","History","youth","social Sciences","art music & cinema","humor","police & thrillers","Religion and spirituality","school","sport & leisure","theater","tourism & travel"]
    var stateData = ["Please select a state","new","satisfying","old"]
    var langData = ["Please select a language","french","arabic","english","other"]
    var selectedValue : String!
    var selectedValuelang : String!
    var selectedValuestate: String!
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
                             to: "http://192.168.1.4:3000/upload/ios", method: .post , headers: headers)
                             .response { resp in
                                 print(resp)
                         }
         }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = UserDefaults.standard.integer(forKey: "UserID")
        print("aaaaaa = ",pickerData[0])
        selectedValue = pickerData[0]
        selectedValuestate = stateData[0]
        selectedValuelang = langData[0]
        
        sell.setOn(false, animated: true)
        picker.delegate = self
        picker.dataSource = self
        langPicker.delegate = self
        langPicker.dataSource = self
        statePicker.delegate = self
        statePicker.dataSource = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        	return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker{
            return pickerData.count
        }else if pickerView == langPicker{
            return langData.count
        }else{
            return stateData.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker{
            return pickerData[row]
        }else if pickerView == langPicker{
            return langData[row]
        }else{
            return stateData[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker{
            selectedValue = pickerData[row]
        }else if pickerView == langPicker{
            selectedValuelang = langData[row]
        }else{
            selectedValuestate = stateData[row]
        }
        
    }
    @IBAction func addbook(){
        if self.verif() == false {
            let title = tftitle.text
            let author = tfauthor.text
            let category = selectedValue
            let language = selectedValuelang
            let status = selectedValuestate
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
            let urlString = "http://192.168.1.4:3000/books/add-book"
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
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func verif() -> Bool{
            var test = false

        if tftitle.text!.isEmpty || tfauthor.text!.isEmpty
               {
            promtAlert(titre: "required",message: "all fields are required !")
                test=true
                       }
           else if(selectedValue == "Please select a category")
            {
            promtAlert(titre: "Category",message: "Select a category")
                test=true
               }
           else if(selectedValuestate == "Please select a state")
            {
                promtAlert(titre: "status",message: "Select a status")
                test=true
               }
            else   if(selectedValuelang == "Please select a language")
            {
                promtAlert(titre: "langage",message: "Select a langage")
                test=true
               }
                return test

        }
    func promtAlert(titre : String, message : String) {
      //creation alert
  let alert = UIAlertController(title :titre,message : message,preferredStyle : .alert)
  //création aciton alert
  let action = UIAlertAction(title : "OK",style : .cancel,handler : nil )
  //affectation action to alert
  alert.addAction(action)
  // presentation affichage alert
  self.present(alert,animated:true)
  }
}
