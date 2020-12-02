//
//  PostViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/19/20.
//

import UIKit

class PostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    var data = ["BookFair","London Review of Books","FairyTail","Moonlight"]
    var cat = ["Romance","Jeunesse","Manga","Psychologie"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        let contentView = cell?.contentView
        let label = contentView?.viewWithTag(1)as! UILabel
        let imageView = contentView?.viewWithTag(2)as! UIImageView
        let label2 = contentView?.viewWithTag(3)as! UILabel
        
        label.text = data[indexPath.row]
        imageView.image = UIImage(named: data[indexPath.row])
        label2.text = cat[indexPath.row]
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
