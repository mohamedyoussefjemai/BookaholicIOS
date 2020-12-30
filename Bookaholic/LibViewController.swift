//
//  LibViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/17/20.
//

import UIKit
import Alamofire

class LibViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var libpost: UISwitch!
    @IBOutlet weak var table: UITableView?
    var data = ["BookFair","London Review of Books","FairyTail","Moonlight"]
    
    var BookImage: [String] = []
    var bookName:[String] = []
    var category:[String] = []
    var author:[String] = []
    var status:[String] = []
    var language:[String] = []
    var visible:[Int] = []
    var price:[Int] = []
    var userName:[String] = []
    var bookid : [Int]=[]
    
    var images : [String]=[]

    
    var eye:[String] = []
    var id : Int!
   
    var bookname: String?
    var auth: String?
    var cat: String?
    var stat: String?
    var lang: String?
    var prix : Int?
    var vis : Int?
    var book_id : Int?
    var image : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.edit, target: self, action: #selector(goPosts))
    }
    @objc func goPosts(){
        performSegue(withIdentifier: "libpost", sender: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        bookName.removeAll()
        category.removeAll()
        author.removeAll()
        status.removeAll()
        language.removeAll()
        visible.removeAll()
        price.removeAll()
        userName.removeAll()
        bookid.removeAll()
        BookImage.removeAll()
        self.library()
    }

    func library(){
        id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.2:3000/books/lib-book/"+String(id!)
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
                           if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                            if list.isEmpty {
                                print("Library is empty")
                            }else{
                                for n in 0...list.count-1 {
                                    print("booook ===== ",list[n]["title"]!!)
                                    self.bookName.append(list[n]["title"]!! as! String)
                                    self.category.append(list[n]["category"]!! as! String)
                                    self.author.append(list[n]["author"]!! as! String)
                                    self.price.append(list[n]["price"] as! Int)
                                    self.language.append(list[n]["language"]!! as! String)
                                    self.visible.append(list[n]["visible"] as! Int)
                                    self.status.append(list[n]["status"]!! as! String)
                                    self.bookid.append(list[n]["id"] as! Int)
                                    self.BookImage.append(list[n]["image"]!! as! String)
                                    self.userName.append(list[n]["username"]!! as! String)
                                    if(list[n]["visible"]!! as! Int == 1){
                                    self.eye.append("visible_eye")
                                    }
                                    else{
                                        self.eye.append("invisible")
                                    }
                                }
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
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            print("Deleting Book ...")
            deleteBook(index: indexPath.row)
            bookName.remove(at: indexPath.row)
            category.remove(at: indexPath.row)
            author.remove(at: indexPath.row)
            status.remove(at: indexPath.row)
            language.remove(at: indexPath.row)
            visible.remove(at: indexPath.row)
            price.remove(at: indexPath.row)
            bookid.remove(at: indexPath.row)
            BookImage.remove(at: indexPath.row)
            eye.remove(at: indexPath.row)
            tableView.reloadData()
        }
       
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "UPDATE") { (action, view, nil) in
            print("update...")
            self.bookname = self.bookName[indexPath.row]
            self.auth = self.author[indexPath.row]
            self.cat = self.category[indexPath.row]
            self.stat = self.status[indexPath.row]
            self.lang = self.language[indexPath.row]
            self.prix = self.price[indexPath.row]
            self.vis = self.visible[indexPath.row]
            self.book_id = self.bookid[indexPath.row]
            self.image = self.BookImage[indexPath.row]
            self.performSegue(withIdentifier: "lib_update", sender: self)
        }
        return UISwipeActionsConfiguration(actions: [update])
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("toul el book name",bookName.count)
        return bookName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("boook name ====>",bookName)
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        let contentView = cell?.contentView
        let label = contentView?.viewWithTag(1)as! UILabel
        let imageView = contentView?.viewWithTag(2)as! UIImageView
        let label2 = contentView?.viewWithTag(3)as! UILabel
        let author = contentView?.viewWithTag(4)as! UILabel
        let eye = contentView?.viewWithTag(5)as! UIButton
        let language = contentView?.viewWithTag(6)as! UILabel
        let username = contentView?.viewWithTag(7)as! UILabel
        let status = contentView?.viewWithTag(8)as! UILabel
        let price = contentView?.viewWithTag(9)as! UILabel
        
        label.text = self.bookName[indexPath.row] as! String
        print(self.bookName[indexPath.row])
        
        let url2 = URL(string: "http://192.168.1.2:3000/uploads/"+self.BookImage[indexPath.row])!
        imageView.loadImge(withUrl: url2)
        
        
        label2.text = self.category[indexPath.row] as! String
        author.text = self.author[indexPath.row] as! String
        language.text = self.language[indexPath.row] as! String
        username.text = self.userName[indexPath.row] as! String
        status.text = self.status[indexPath.row] as! String
        if(status.text == "new"){
            status.textColor = .green
        }else if(status.text == "satisfying"){
            status.textColor = .blue
        }else{
            status.textColor = .red
        }
        price.text = String(self.price[indexPath.row])+" DT"
        eye.setImage(UIImage(named: self.eye[indexPath.row]), for: .normal)
       
        return cell!
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lib_update"{
            let destination = segue.destination as! UINavigationController
            let update = destination.topViewController as! UpDateBookViewController
            update.bookname = bookname
            update.auth = auth
            update.cat = cat
            update.lang = lang
            update.prix = prix
            update.vis = vis
            update.stat = stat
            update.book_id = book_id
            update.image = image
        }
           
            
        
      
    }
    
    func deleteBook(index: Int){
        let bid = bookid[index]
        let url = "http://192.168.1.2:3000/books/delete-book/"+String(bid)
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

