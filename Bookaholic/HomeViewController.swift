//
//  HomeViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/26/20.
//

import UIKit
import Alamofire
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate, btnincell {
    
    
    func onClick(index: Int) {
        print(index)
     
        let title = self.bookName[index]
        let category = self.category[index]
        let author = self.author[index]
        let price = String(self.price[index])
        let status = self.status[index]
        let username = self.userName[index]
        let language = self.language[index]
        let visible = self.visible[index]
        let user = UserDefaults.standard.string(forKey: "UserID")!
      //  let image = self.bookImage[indexPath.row]
        let bookid = self.bookid[index]
    
        let params = ["title":title,
                      "author" : author,
                            "price" : price,
                            "category": category,
                            "visible" : String(visible),
                          "language" : language,
                          "status" : status,
                          "user" : String(user),
                         "image":"image",
                          "book":String(bookid),
                          "username" : username] as? Dictionary<String, String>
              let urlString = "http://192.168.1.4:3000/favoris/add-favoris"
              let headers :HTTPHeaders = ["Content-Type": "application/json"]
              AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
              response in
                switch response.result {
                              case .success:
                                  if let data = response.data {
                                      let json = String(data: data, encoding: String.Encoding.utf8)
                                    self.showToast(message: "book added to fav")
                                     print("Book added to fav ")
                                    print(json!)
                                      }
      
                                  break
                              case .failure(let error):
      
                                  print(error)
                              }
              }
    }
    
    
    @IBOutlet weak var table: UITableView!
    var bookName:[String] = []
    var category:[String] = []
    var author:[String] = []
    var status:[String] = []
    var language:[String] = []
    var visible:[Int] = []
    var price:[Int] = []
    var userName:[String] = []
    var bookid : [Int]=[]
    var bookImage : [UIImage]=[]
   
    
    
    var bookimage: UIImageView?
    var bookname: String?
    var auth: String?
    var cat: String?
    var stat: String?
    var lang: String?
    var prix : Int?
    var vis : Int?
    var book_id : Int?
    var id : Int!
    @IBOutlet weak var collectionView1: UICollectionView!
    var catlist = [UIImage(named:"All"),
                   UIImage(named:"romance & new adult"),
                   UIImage(named:"adventure"),
                   UIImage(named:"literature"),
                   UIImage(named:"comic & mangas"),
                   UIImage(named:"Personal development"),
                   UIImage(named:"Health & cooking"),
                   UIImage(named:"History"),
                   UIImage(named:"youth"),
                   UIImage(named:"social Sciences"),
                   UIImage(named:"art music & cinema"),
                   UIImage(named:"humor"),
                   UIImage(named:"police & thrillers"),
                   UIImage(named:"Religion and spirituality"),
                   UIImage(named:"school"),
                   UIImage(named:"sport & leisure"),
                   UIImage(named:"theater"),
                   UIImage(named:"tourism & travel")]
                  
    var catanames = ["All","romance & new adult", "adventure", "literature","comic & mangas","Personal development","Health & cooking","History","youth","social Sciences","art music & cinema","humor","police & thrillers","Religion and spirituality","school","sport & leisure","theater","tourism & travel"]
    var data = [UIImage(named:"BookFair"),
                UIImage(named:"London Review of Books"),
                UIImage(named:"FairyTail"),
                UIImage(named:"Moonlight")]
    
    override func viewDidAppear(_ animated: Bool) {
        bookName = []
        category = []
        author = []
        price = []
        Home()
    }
    func tap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_gesture:)))
        tapGesture.numberOfTapsRequired = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        collectionView1.delegate = self
        collectionView1.dataSource = self 
        tap()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView1{
            return catlist.count
        }
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath)as! HomeCVC
            cell1.catimage.image = catlist[indexPath.row]
        cell1.catname.text = catanames[indexPath.row]
            return cell1
              
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bookName.removeAll()
        category.removeAll()
        author.removeAll()
        status.removeAll()
        language.removeAll()
        visible.removeAll()
        price.removeAll()
        userName.removeAll()
        bookid.removeAll()
        bookImage.removeAll()
        let categoryname = catanames[indexPath.row]
        let url2 = "http://192.168.1.4:3000/books/read-book-category/"+categoryname
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url2, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                            if(list.isEmpty ){
                                print("empty category")
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
                                self.userName.append(list[n]["username"]!! as! String)
                            }
                                
                            }
                            self.table?.reloadData()
                                        }
                                }
                                  }
                              break
                          case .failure(let error):
                              print("erreur ==",error)
                          }
          }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell") as? HomeTableViewCell
        cell?.cellDelegate = self
        cell?.index = indexPath
        let contentView = cell?.contentView
        let label = contentView?.viewWithTag(1)as! UILabel
        bookimage = contentView?.viewWithTag(2)as! UIImageView
        let category = contentView?.viewWithTag(3)as! UILabel
        let author = contentView?.viewWithTag(4)as! UILabel
        let heart = contentView?.viewWithTag(5)as! UIButton
        let language = contentView?.viewWithTag(6)as! UILabel
        let username = contentView?.viewWithTag(7)as! UILabel
        let status = contentView?.viewWithTag(8)as! UILabel
        let price = contentView?.viewWithTag(9)as! UILabel
        /// /// /// ///
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_gesture:)))
//        tapGesture.numberOfTapsRequired = 2
//        bookimage?.isUserInteractionEnabled = true
//        bookimage?.addGestureRecognizer(tapGesture)
        
        ///////
        label.text = self.bookName[indexPath.row] as! String
        print(self.bookName[indexPath.row])
        bookimage!.image = UIImage(named: "FairyTail")
        category.text = self.category[indexPath.row] as! String
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
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_gesture:)))
        tapGesture.numberOfTapsRequired = 2
        bookimage?.isUserInteractionEnabled = true
        bookimage?.addGestureRecognizer(tapGesture)
    }
    
    func Home(){
        let url = "http://192.168.1.4:3000/books/"
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
                                self.bookName.append(list[n]["title"]!! as! String)
                                self.category.append(list[n]["category"]!! as! String)
                                self.author.append(list[n]["author"]!! as! String)
                                self.price.append(list[n]["price"] as! Int)
                                self.language.append(list[n]["language"]!! as! String)
                                self.visible.append(list[n]["visible"] as! Int)
                                self.status.append(list[n]["status"]!! as! String)
                                self.bookid.append(list[n]["id"] as! Int)
                                self.userName.append(list[n]["username"]!! as! String)
                            }
                            self.table?.reloadData()
                                        }
                                }
                                  }
                              break
                          case .failure(let error):
                              print("erreur ==",error)
                          }
          }
    }
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-75, y: self.view.frame.height - 150, width: 150, height: 40))
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut) {
            toastLabel.alpha = 0.0
            
        } completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
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
        func isfav(){
        
    }
    @objc func didDoubleTap(_gesture: UIGestureRecognizer){
        
        print("image doubel taaaaap")
    }

    ///end
}