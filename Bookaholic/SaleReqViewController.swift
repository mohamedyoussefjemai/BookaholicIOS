//
//  SaleReqViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/30/20.
//

import UIKit
import Alamofire
class SaleReqViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let username = UserDefaults.standard.string(forKey: "UserName")
    @IBOutlet weak var table: UITableView!
    var ids : [Int] = []
    var from : [String]=[]
    var book : [String]=[]
    var price : [Int]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        from.removeAll()
        book.removeAll()
        price.removeAll()
        self.saleReq()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "mycell")
        let contentView = cell?.contentView
        let from = contentView?.viewWithTag(1)as! UILabel
        let book = contentView?.viewWithTag(2)as! UILabel
        let price = contentView?.viewWithTag(3)as! UILabel
        from.text = self.from[indexPath.row] as! String
        book.text = self.book[indexPath.row] as! String
        price.text = String(self.price[indexPath.row])+" DT"
        return cell!
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let refuse = UIContextualAction(style: .normal, title: "Refuse") { (action, view, nil) in
            print ("refusit el sale !")
            let username = UserDefaults.standard.string(forKey: "UserName")
            let id = self.ids[indexPath.row]
            let params = ["usernameSender": self.from[indexPath.row],
                          "usernameReceiver" : username,
                          "title" : self.book[indexPath.row]] as? Dictionary<String, String>
            let urlString = "http://192.168.1.4:3000/requests/refuse-sale-request/"+String(id)
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print("response ==== ",response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                   // self.dismiss(animated: false, completion: nil)
                                    
                                    self.table?.reloadData()
                                }
                                self.table?.reloadData()
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
            self.ids.remove(at: indexPath.row)
            self.from.remove(at: indexPath.row)
            self.book.remove(at: indexPath.row)
            self.price.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [refuse])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accept = UIContextualAction(style: .normal, title: "Accept") { (action, view, nil) in
            print ("acceptit el sale !")
            let id = self.ids[indexPath.row]
            let username = UserDefaults.standard.string(forKey: "UserName")
            //let price =
            print("sender")
            let params = ["usernameSender": self.from[indexPath.row],
                          "usernameReceiver" : username,
                          "titlechange" : self.book[indexPath.row]] as? Dictionary<String, String>
            let urlString = "http://192.168.1.4:3000/requests/accept-sale-request/"+String(id)
            let headers :HTTPHeaders = ["Content-Type": "application/json"]
            AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
              switch response.result {
                            case .success:
                                print("response ==== ",response)
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                   // self.dismiss(animated: false, completion: nil)
                                    
                                    self.table?.reloadData()
                                }
                                self.table?.reloadData()
                                break
                            case .failure(let error):
                                
                                print(error)
                            }
            }
            self.ids.remove(at: indexPath.row)
            self.from.remove(at: indexPath.row)
            self.book.remove(at: indexPath.row)
            self.price.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [accept])
    }
    func saleReq(){
        //id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.4:3000/requests/read-sale-received/"+String(username!)
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
                                print("no sale received")
                            }else{
                                for n in 0...list.count-1 {
                                    self.from.append(list[n]["sender"]!! as! String)
                                    self.book.append(list[n]["title"]!! as! String)
                                    self.price.append(list[n]["price"] as! Int)
                                    self.ids.append(list[n]["id"] as! Int)
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
