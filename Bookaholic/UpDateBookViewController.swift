//
//  UpDateBookViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/9/20.
//

import UIKit
import Alamofire
class UpDateBookViewController: UIViewController {

    @IBOutlet var updateView: UIView!
    @IBOutlet weak var tfprice: UITextField!
    @IBOutlet weak var labprice: UILabel!
    @IBOutlet weak var sell: UISwitch!
    @IBOutlet weak var tflanguage: UITextField!
    @IBOutlet weak var tfstatus: UITextField!
    @IBOutlet weak var tfcategory: UITextField!
    @IBOutlet weak var tfauthor: UITextField!
    @IBOutlet weak var tftitle: UITextField!
    
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
    override func viewDidLoad() {
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
                    "image":"image",
                    "username" : username!] as? Dictionary<String, String>
        let urlString = "http://192.168.1.6:3000/books/update-book/"+String(book_id!)
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
    
}

    


