//
//  UpDateBookViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/9/20.
//

import UIKit
import Alamofire
class UpDateBookViewController: UIViewController ,UINavigationControllerDelegate ,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    

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
    var selectedValuecat : String!
    var selectedValuelang : String!
    var selectedValuestate: String!
    @IBOutlet weak var catpicker: UIPickerView!
    
    @IBOutlet weak var statepicker: UIPickerView!
    
    @IBOutlet weak var langPicker: UIPickerView!
    var filenameImage: String = ""
    var imagePicker: UIImagePickerController!
        var   fileName2 = String();
        var url2: URL!
    
    let catData = ["Please select a category","romance & new adult", "adventure", "literature","comic & mangas","Personal development","Health & cooking","History","youth","social Sciences","art music & cinema","humor","police & thrillers","Religion and spirituality","school","sport & leisure","theater","tourism & travel"]
    
    var stateData = ["Please select a state","new","satisfying","old"]
    
    var langData = ["Please select a language","french","arabic","english","other"]
        enum ImageSource {
            case photoLibrary
            case camera
        }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == catpicker{
            return catData.count
        }else if pickerView == langPicker{
            return langData.count
        }else{
            return stateData.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == catpicker{
            return catData[row]
        }else if pickerView == langPicker{
            return langData[row]
        }else{
            return stateData[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == catpicker{
            selectedValuecat = catData[row]
        }else if pickerView == langPicker{
            selectedValuelang = langData[row]
        }else{
            selectedValuestate = stateData[row]
        }
        
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
        
        userID = UserDefaults.standard.integer(forKey: "UserID")
        super.viewDidLoad()
        catpicker.delegate = self
        catpicker.dataSource = self
        langPicker.delegate = self
        langPicker.dataSource = self
        statepicker.delegate = self
        statepicker.dataSource = self
        tftitle.text = bookname
        tfauthor.text = auth
        let row = catData.firstIndex(of: cat!)
        catpicker.selectRow(row!, inComponent: 0, animated: true)
        selectedValuecat = catData[row!]
        let row2 = stateData.firstIndex(of: stat!)
        selectedValuestate = stateData[row2!]
        statepicker.selectRow(row2!, inComponent: 0, animated: true)
        let row3 = langData.firstIndex(of: lang!)
        selectedValuelang = langData[row3!]
        langPicker.selectRow(row3!, inComponent: 0, animated: true)
        tfprice.text = String(prix!)
        if(vis != 0){
            tfprice.isHidden = false
            labprice.isHidden = false
            
            sell.setOn(true, animated: true)
        }else{
            sell.setOn(false, animated: true)
            
        }
        let url2 = URL(string: "http://192.168.1.4:3000/uploads/"+image!)!
self.bookimage.lodImage(withUrl: url2)
    }
    
    @IBAction func update(){
        if verif() == false {
            let user = Int(UserDefaults.standard.string(forKey: "UserID")!)
            let username = UserDefaults.standard.string(forKey: "UserName")
            let title = tftitle.text
            
            let author = tfauthor.text
           
            let category = selectedValuecat
            
            let status = selectedValuestate
            
            let language = selectedValuelang
            
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
            let urlString = "http://192.168.1.4:3000/books/update-book/"+String(book_id!)
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
        


}
    func verif() -> Bool{
            var test = false

        if tftitle.text!.isEmpty || tfauthor.text!.isEmpty
               {
            promtAlert(titre: "required",message: "all fields are required !")
                test=true
                       }
           else if(selectedValuecat == "Please select a category")
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


