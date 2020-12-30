//
//  BuyReqViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/30/20.
//

import UIKit
import Alamofire
class BuyReqViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let username = UserDefaults.standard.string(forKey: "UserName")
    @IBOutlet weak var table: UITableView!
    var to : [String]=[]
    var book : [String]=[]
    var price : [Int]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        to.removeAll()
        book.removeAll()
        price.removeAll()
        self.buyReq()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
       let contentView = cell?.contentView
        let to = contentView?.viewWithTag(1) as! UILabel
        let book = contentView?.viewWithTag(2) as! UILabel
        let price = contentView?.viewWithTag(3)as! UILabel
            
        to.text = self.to[indexPath.row] as! String
        book.text = self.book[indexPath.row] as! String
        price.text = String(self.price[indexPath.row])+" DT"
        return cell!
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "delete") { (action, view, nil) in
            print ("fasa5t el request !")
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func buyReq(){
        //id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.2:3000/requests/read-sale-sended/"+String(username!)
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
                                print("You dont have any buy request sended !")
                            }else{
                                for n in 0...list.count-1 {
                                    self.to.append(list[n]["receiver"]!! as! String)
                                    self.book.append(list[n]["title"]!! as! String)
                                    self.price.append(list[n]["price"] as! Int)
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