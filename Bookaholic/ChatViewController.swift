//
//  ChatViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
  
    @IBOutlet weak var mytable: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytable.dataSource = self
        self.mytable.delegate = self
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        cell?.layer.cornerRadius = 20
        
        let contentView = cell?.contentView
        let catimage = contentView?.viewWithTag(1)as! UIImageView
        let catname = contentView?.viewWithTag(2)as! UILabel
       
        catimage.image = catlist[indexPath.row]
        catname.text = catanames[indexPath.row]
        return cell!
    }
    
}
