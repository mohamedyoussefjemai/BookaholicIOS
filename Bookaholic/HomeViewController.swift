//
//  HomeViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/26/20.
//

import UIKit
import Alamofire
import QuartzCore
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
        let image = self.BookImage[index]
        let bookid = self.bookid[index]
    
        
        let params = ["title":title,
                      "author" : author,
                      "price" : price,
                      "category": category,
                      "visible" : String(visible),
                      "language" : language,
                      "status" : status,
                      "user" : String(user),
                      "image":image,
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
    var messenger:[String] = []
    var author:[String] = []
    var status:[String] = []
    var language:[String] = []
    var visible:[Int] = []
    var price:[Int] = []
    var userName:[String] = []
    var bookid : [Int]=[]
    var BookImage: [String] = []
    var userbookid : [Int]=[]
    var favbID : [Int]=[]
    
    var bookname: String?
    var auth: String?
    var cat: String?
    var stat: String?
    var lang: String?
    var prix : Int?
    var vis : Int?
    var book_id : Int?
    var id : Int!
    var bmessenger : String?
    var bname: String?
    var bauth: String?
    var bcat: String?
    var bstat: String?
    var blang : String?
    var bprix : Int?
    var busername : String?
    var buserid : Int?
    var bbookimage: String?
    
    
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
                   UIImage(named:"Religion & spirituality"),
                   UIImage(named:"school"),
                   UIImage(named:"sport & leisure"),
                   UIImage(named:"theater"),
                   UIImage(named:"tourism & travel")]
                  
    var catanames = ["All","romance & new adult", "adventure", "literature","comic & mangas","Personal development","Health & cooking","History","youth","social Sciences","art music & cinema","humor","police & thrillers","Religion & spirituality","school","sport & leisure","theater","tourism & travel"]
    var data = [UIImage(named:"BookFair"),
                UIImage(named:"London Review of Books"),
                UIImage(named:"FairyTail"),
                UIImage(named:"Moonlight")]
    
    override func viewWillAppear(_ animated: Bool) {
       // getFav()
       // print("fav ids = ",favbID)
    }
    override func viewDidAppear(_ animated: Bool) {
        print("home is here")
        bookName = []
        category = []
        author = []
        price = []
        userName = []
        Home()
        table.reloadData()
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
        BookImage.removeAll()
        var categoryname = catanames[indexPath.row]
        switch categoryname{
        case "romance & new adult":
            categoryname = "romance"
        case "comic & mangas":
            categoryname = "mangas"
        case "Personal development":
            categoryname = "devper"
        case "Health & cooking":
            categoryname = "health"
        case "social Sciences":
            categoryname = "social"
        case "art music & cinema":
            categoryname = "art"
        case "police & thrillers":
            categoryname = "police"
        case "Religion & spirituality":
            categoryname = "religion"
        case "sport & leisure":
            categoryname = "sport"
        case "tourism & travel":
            categoryname = "travel"
        default:
            categoryname = catanames[indexPath.row]
        }
        var url2 = "test"
        if categoryname == "All"{
             url2 = "http://192.168.1.4:3000/books/"
        }else{
       url2 = "http://192.168.1.4:3000/books/read-book-category/"+categoryname
        }
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
                                self.BookImage.append(list[n]["image"]!! as! String)
                                
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
        let imageView = contentView?.viewWithTag(2)as! UIImageView
        let category = contentView?.viewWithTag(3)as! UILabel
        let author = contentView?.viewWithTag(4)as! UILabel
        let heart = contentView?.viewWithTag(5)as! UIButton
        let language = contentView?.viewWithTag(6)as! UILabel
        let username = contentView?.viewWithTag(7)as! UILabel
        let status = contentView?.viewWithTag(8)as! UILabel
        let price = contentView?.viewWithTag(9)as! UILabel
        
      
        ///////
        label.text = self.bookName[indexPath.row] as! String
        category.text = self.category[indexPath.row] as! String
        author.text = self.author[indexPath.row] as! String
        language.text = self.language[indexPath.row] as! String
        username.text = self.userName[indexPath.row] as! String
        status.text = self.status[indexPath.row] as! String
        let url2 = URL(string: "http://192.168.1.4:3000/uploads/"+self.BookImage[indexPath.row] )!
        imageView.loadImge(withUrl: url2)
        	
        status.textColor = .white
        if(status.text == "new"){
            status.backgroundColor = .systemGreen
            status.layer.cornerRadius = 5
            status.layer.masksToBounds = true
        }else if(status.text == "satisfying"){
            
                status.backgroundColor = .systemBlue
                status.layer.cornerRadius = 5
                status.layer.masksToBounds = true
        }else{
                status.backgroundColor = .systemRed
                status.layer.cornerRadius = 5
                status.layer.masksToBounds = true
        }
        if username.text == UserDefaults.standard.string(forKey: "UserName"){
            cell?.heart.isHidden = true
        }else{
            cell?.heart.isHidden = false
        }
        price.text = String(self.price[indexPath.row])+" DT"
        if favbID.contains(bookid[indexPath.row]) {
        cell?.heart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        }else{
            cell?.heart.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
       return cell!
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_gesture:)))
//        tapGesture.numberOfTapsRequired = 2
//        bookimage?.isUserInteractionEnabled = true
//        bookimage?.addGestureRecognizer(tapGesture)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row ",indexPath.row," selected")
        bname = bookName[indexPath.row]
        bauth = author [indexPath.row]
        bcat = category [indexPath.row]
        bstat = status [indexPath.row]
        blang = language [indexPath.row]
        bprix = price [indexPath.row]
        busername = userName[indexPath.row]
        buserid = userbookid[indexPath.row]
        bbookimage = BookImage[indexPath.row]
        performSegue(withIdentifier: "showbook", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? ShowBookViewController
        destination?.name = bname
        destination?.author = bauth
        destination?.category = bcat
        destination?.state = bstat
        destination?.lang = blang
        destination?.price = bprix
        destination?.username = busername
        destination?.userID = buserid
        destination?.bookimage = bbookimage

    }
    func Home(){
        getFav()
        let url = "http://192.168.1.4:3000/books/"
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
                          case .success:
                             // print(response)
                              if let data = response.data {
                                  let json = String(data: data, encoding: String.Encoding.utf8)
                              
                                let data = json!.data(using: .utf8)!
                               do {
                                   let jsonArray = json!
                                    //print("jSONARRAY ===",jsonArray)
                           if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                            for n in 0...list.count-1 {
                               // print("booook ===== ",list[n]["title"]!!)
                                self.bookName.append(list[n]["title"]!! as! String)
                                self.category.append(list[n]["category"]!! as! String)
                                self.author.append(list[n]["author"]!! as! String)
                                self.price.append(list[n]["price"] as! Int)
                                self.language.append(list[n]["language"]!! as! String)
                                self.visible.append(list[n]["visible"] as! Int)
                                self.status.append(list[n]["status"]!! as! String)
                                self.bookid.append(list[n]["id"] as! Int)
                                self.userName.append(list[n]["username"]!! as! String)
                                self.userbookid.append(list[n]["user"] as! Int)
                                self.BookImage.append(list[n]["image"] as! String)
                             
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
        toastLabel.backgroundColor = .systemGreen
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
    func getFav(){
        favbID = []
print("fav ids == ",favbID)
        let id = Int(UserDefaults.standard.string(forKey: "UserID")!)
        let url = "http://192.168.1.4:3000/favoris/read-favoris/"+String(id!)
    let headers :HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .get , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
                          case .success:
                              if let data = response.data {
                                  let json = String(data: data, encoding: String.Encoding.utf8)
                                let data = json!.data(using: .utf8)!
                               do {
                                   let jsonArray = json!
                           if let list = self.convertToDictionary(text: jsonArray) as? [AnyObject] {
                            if list.isEmpty{
                                print("empty fav")
                            }else{
                                for n in 0...list.count-1 {
                                    self.favbID.append(list[n]["book"]!! as! Int)
                                }
                            }
                            
                           }
                                }
                                print("fav ids === ",self.favbID)
                                  }
                              break
                          case .failure(let error):
                              print("erreur ==",error)
                          }
          }
    }
    ///end
    
}
