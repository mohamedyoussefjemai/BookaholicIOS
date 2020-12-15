//
//  ShowBookViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/14/20.
//

import UIKit
import Alamofire
class ShowBookViewController: UIViewController {

    @IBOutlet weak var btnusername: UIButton!
    @IBOutlet weak var tfPrice: UILabel!
    @IBOutlet weak var tfCateg: UILabel!
    @IBOutlet weak var tfState: UILabel!
    @IBOutlet weak var tfLang: UILabel!
    @IBOutlet weak var tfAuthor: UILabel!
    @IBOutlet weak var tfName: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var img : UIImage?
    var name : String?
    var author : String?
    var lang : String?
    var state : String?
    var category : String?
    var price : Int?
    var username : String?
    var userID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfName.text = name
        tfAuthor.text = author
        tfLang.text = lang
        tfState.text = state
        tfCateg.text = category
        tfPrice.text = String(price!)+" DT"
        btnusername.setTitle(username, for: .normal)
        image.image = UIImage(named: "FairyTail")
    }
    @IBAction func showUser(){
        performSegue(withIdentifier: "showuser", sender: self)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? ShowUserViewController
        destination?.username = username
        destination?.userID = userID
    }

}
