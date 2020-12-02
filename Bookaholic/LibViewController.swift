//
//  LibViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/17/20.
//

import UIKit
import Alamofire

class LibViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView?
    var data = ["BookFair","London Review of Books","FairyTail","Moonlight"]
    var bookName:[String] = []
    var category:[String] = []
    var id : Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.library()
       
    }
    
    func library(){
        let url = "http://192.168.1.4:3000/books/lib-book/"+String(id!)
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
                            
                            for n in 0...list.count-1 {
                                print("booook ===== ",list[n]["title"]!!)
                                self.bookName.append(list[n]["title"]!! as! String)
                                self.category.append(list[n]["category"]!! as! String)
                            }
                            self.table?.reloadData()
                            print("bookName = ",self.bookName)
                            print("category = ",self.category)
                
                  
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
        
        label.text = self.bookName[indexPath.row] as! String
        print(self.bookName[indexPath.row])
        imageView.image = UIImage(named: "FairyTail")
        label2.text = self.category[indexPath.row] as! String
        return cell!
    }
    
    
}

