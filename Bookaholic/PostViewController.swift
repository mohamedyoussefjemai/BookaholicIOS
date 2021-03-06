//
//  PostViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/19/20.
//

import UIKit
import Alamofire
class PostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var table: UITableView!
    var BookImage: [String] = []
    var bookname:[String] = []
    var category:[String] = []
    var author:[String] = []
    var status:[String] = []
    var language:[String] = []
    var visible:[Int] = []
    var price:[Int] = []
    var userName:[String] = []
    var bookid : [Int]=[]
    var eye:[String] = []
    var id : Int!
    
    
    override func viewDidLoad() {
//        self.Posts()
        super.viewDidLoad()
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bookname = []
        category = []
        author = []
        status = []
        language = []
        visible = []
        price = []
        userName = []
        bookid = []
    Posts()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        let contentView = cell?.contentView
        let bookname = contentView?.viewWithTag(1)as! UILabel
        let imageView = contentView?.viewWithTag(2)as! UIImageView
        let category = contentView?.viewWithTag(3)as! UILabel
        let eye = contentView?.viewWithTag(5)as! UIButton
       let author = contentView?.viewWithTag(4)as! UILabel
        let language = contentView?.viewWithTag(6)as! UILabel
        let username = contentView?.viewWithTag(7)as! UILabel
        let status = contentView?.viewWithTag(8)as! UILabel
        let price = contentView?.viewWithTag(9)as! UILabel
        
        bookname.text = self.bookname[indexPath.row] as! String
        imageView.image = UIImage(named: "FairyTail")
        category.text = self.category[indexPath.row]
        price.text = self.price[indexPath.row] as? String
        author.text = self.author[indexPath.row]
        language.text = self.language[indexPath.row] as! String
        username.text = self.userName[indexPath.row] as! String
        status.text = self.status[indexPath.row] as! String
        
        let url2 = URL(string: "http://192.168.1.2:3000/uploads/"+self.BookImage[indexPath.row])!
        imageView.loadImge(withUrl: url2)
        
        
        
        
        eye.setImage(UIImage(named: self.eye[indexPath.row]), for: .normal)
        if(status.text == "new"){
            status.textColor = .green
        }else if(status.text == "satisfying"){
            status.textColor = .blue
        }else{
            status.textColor = .red
        }
        price.text = String(self.price[indexPath.row])+" DT"
        return cell!
    }
    
    func Posts(){
//        let tabbar = tabBarController as! MyTabBar
//        id = tabbar.userID
       id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.2:3000/books/post-book/"+String(id!)
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
   
                    print(response)
   
            switch response.result {
                          case .success:
                              print(response)
                              if let data = response.data {
                                  let json = String(data: data, encoding: String.Encoding.utf8)
                              
                                let data = json!.data(using: .utf8)!
                               do {
                                   let jsonArray = json!
                                    print("jSONARRAY ===",jsonArray)
                                
                           if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                            if list.isEmpty{
                                print("posts is empty")
                            }else{
                                for n in 0...list.count-1 {
                                    print("booook ===== ",list[n]["title"]!!)
                                    self.bookname.append(list[n]["title"]!! as! String)
                                    self.category.append(list[n]["category"]!! as! String)
                                    self.author.append(list[n]["author"]!! as! String)
                                    self.price.append(list[n]["price"] as! Int)
                                    self.language.append(list[n]["language"]!! as! String)
                                    self.visible.append(list[n]["visible"] as! Int)
                                    self.status.append(list[n]["status"]!! as! String)
                                    self.bookid.append(list[n]["id"] as! Int)
                                    self.userName.append(list[n]["username"]!! as! String)
                                    
                                    self.BookImage.append(list[n]["image"]!! as! String)

                                    if(list[n]["visible"]!! as! Int == 1){
                                    self.eye.append("visible_eye")
                                    }
                                    else{
                                        self.eye.append("invisible")
                                    }
                                    
                                }
                            }
                            
                            
                                        }
                              
                               self.table?.reloadData()
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
    
   
    
    
    
    
    


}
