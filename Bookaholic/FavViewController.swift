//
//  FavViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/19/20.
//

import UIKit
import Alamofire

class FavViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var table: UITableView!
    var bookname: [String] = []
    var category:[String] = []
    var author:[String] = []
    var price:[Int] = []
    var status:[String] = []
    var language:[String] = []
    var visible:[Int] = []
    var userName:[String] = []
    var bookid : [Int]=[]
    var images : [String]=[]
    var id : Int!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        cell?.layer.cornerRadius = 20
        let contentView = cell?.contentView
        let bookname = contentView?.viewWithTag(1)as! UILabel
        let imageView = contentView?.viewWithTag(2)as! UIImageView
        let category = contentView?.viewWithTag(3)as! UILabel
        let price = contentView?.viewWithTag(9)as! UILabel
       let author = contentView?.viewWithTag(4)as! UILabel
        let language = contentView?.viewWithTag(6)as! UILabel
        let status = contentView?.viewWithTag(8)as! UILabel
        
        bookname.text = self.bookname[indexPath.row] as! String
        imageView.image = UIImage(named: "FairyTail")
        category.text = self.category[indexPath.row] as! String
        author.text = self.author[indexPath.row] as! String
        language.text = self.language[indexPath.row] as! String
        status.text = self.status[indexPath.row] as! String
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            print("Deleting Book ...")
            deleteBook(index: indexPath.row)
            bookname.remove(at: indexPath.row)
            category.remove(at: indexPath.row)
            author.remove(at: indexPath.row)
            status.remove(at: indexPath.row)
            language.remove(at: indexPath.row)
            visible.remove(at: indexPath.row)
            price.remove(at: indexPath.row)
            bookid.remove(at: indexPath.row)
            images.remove(at: indexPath.row)
            tableView.reloadData()
        }
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        bookname.removeAll()
        category.removeAll()
        author.removeAll()
        status.removeAll()
        language.removeAll()
        visible.removeAll()
        price.removeAll()
        userName.removeAll()
        bookid.removeAll()
        images.removeAll()
        self.favorites()
        
    }
    func favorites(){
        id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.4:3000/favoris/read-favoris/"+String(id!)
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                            
                            for n in 0...list.count-1 {
                                print("booook ===== ",list[n]["title"]!!)
                                self.bookname.append(list[n]["title"]!! as! String)
                                self.category.append(list[n]["category"]!! as! String)
                                self.author.append(list[n]["author"]!! as! String)
                                self.price.append(list[n]["price"] as! Int)
                                self.language.append(list[n]["language"]!! as! String)
                                self.visible.append(list[n]["visible"] as! Int)
                                self.status.append(list[n]["status"]!! as! String)
                                self.bookid.append(list[n]["book"] as! Int)
                                self.images.append(list[n]["image"]!! as! String)
                                self.userName.append(list[n]["username"]!! as! String)
                                
                                
                            }
                            self.table?.reloadData()
                                        }
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
    func deleteBook(index: Int){
        id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let bid = bookid[index]
        let url = "http://192.168.1.4:3000/favoris/delete-favoris/"+String(id)+"/"+String(bid)
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .delete , encoding: JSONEncoding.default, headers: headers).responseJSON { AFdata in
               do {
                   guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                       print("Error: Cannot convert data to JSON object")
                       return
                   }
                   guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                       print("Error: Cannot convert JSON object to Pretty JSON data")
                       return
                   }
                   guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                       print("Error: Could print JSON in String")
                       return
                   }

                   print(prettyPrintedJson)
               } catch {
                   print("Error: Trying to convert JSON data to string")
                   return
               }
           }
    }
}
