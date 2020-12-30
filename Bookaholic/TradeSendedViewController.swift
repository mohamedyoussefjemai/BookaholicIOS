//
//  TradeSendedViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit
import Alamofire
class TradeSendedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    @IBOutlet weak var table: UITableView!
    var receiver:[String] = []
    var senderbook:[String] = []
    var receiverbook:[String] = []
    var price:[Int] = [0]
    let username = UserDefaults.standard.string(forKey: "UserName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        receiver.removeAll()
        senderbook.removeAll()
        receiverbook.removeAll()
        price.removeAll()
        self.tradeSended()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiver.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        let contentView = cell?.contentView
        let receiverName = contentView?.viewWithTag(5) as! UILabel
        let mybook = contentView?.viewWithTag(3)as! UILabel
        let hisbook = contentView?.viewWithTag(2)as! UILabel
        let price = contentView?.viewWithTag(4)as! UILabel
        
        receiverName.text = self.receiver[indexPath.row] as! String
        print("receiver = ",self.receiver[indexPath.row])
        hisbook.text = self.receiverbook[indexPath.row] as! String
        print("his book = ",self.receiverbook[indexPath.row])
        mybook.text = self.senderbook[indexPath.row] as! String
        print("my book = ",self.senderbook[indexPath.row])
        price.text = String(self.price[indexPath.row])+" DT"
        print("price = ",self.price[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
            print ("fasa5t el trade request!")
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tradeSended(){
        //id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.2:3000/requests/read-trade-sended/"+String(username!)
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
                                print("no trade sended")
                            }else{
                                for n in 0...list.count-1 {
                                    self.receiver.append(list[n]["receiver"]!! as! String)
                                    self.receiverbook.append(list[n]["title"]!! as! String)
                                    self.senderbook.append(list[n]["titlechange"]!! as! String)
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
