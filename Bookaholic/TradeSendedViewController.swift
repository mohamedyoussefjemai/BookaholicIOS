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
    var ids : [Int] = []
    var receiver:[String] = []
    var senderbook:[String] = []
    var receiverbook:[String] = []
    var price:[Int] = [0]
    var Etat:[String] = []
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
        let etat = contentView?.viewWithTag(6)as! UILabel
        
        receiverName.text = self.receiver[indexPath.row] as! String
        print("receiver = ",self.receiver[indexPath.row])
        hisbook.text = self.receiverbook[indexPath.row] as! String
        print("his book = ",self.receiverbook[indexPath.row])
        mybook.text = self.senderbook[indexPath.row] as! String
        print("my book = ",self.senderbook[indexPath.row])
        price.text = String(self.price[indexPath.row])+" DT"
        print("price = ",self.price[indexPath.row])
        etat.text = String(self.Etat[indexPath.row])
        if(etat.text == "accepted"){
            etat.textColor = .green
        }else if(etat.text == "waiting"){
            etat.textColor = .orange
        }else{
            etat.textColor = .red
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, nil) in
            print ("fasa5t el trade request!")
            let id = self.ids[indexPath.row]
            print("id ) ))))) ",id)
            self.delete(id: id)
            self.ids.remove(at: indexPath.row)
            self.receiver.remove(at: indexPath.row)
            self.senderbook.remove(at: indexPath.row)
            self.receiverbook.remove(at: indexPath.row)
            self.price.remove(at: indexPath.row)
            self.Etat.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func delete(id: Int){
        let url = "http://192.168.1.4:3000/requests/delete-trade-request/"+String(id)
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
    func tradeSended(){
        //id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.4:3000/requests/read-trade-sended/"+String(username!)
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
                                    self.Etat.append(list[n]["etat"] as! String)
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
