//
//  MyTabBar.swift
//  Bookaholic
//
//  Created by wassim on 12/6/20.
//

import UIKit
import Alamofire

class MyTabBar: UITabBarController {
    var mailtabar : String?
    var username : String?
    var userID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
//        print(mailtabar!)
//        print(userID!)
//        print("hellloooo "+mailtabar!," from tab bar ")
//        print(username!)
//        UserDefaults.standard.set(mailtabar, forKey: "Email")
//        UserDefaults.standard.set(username, forKey: "UserName")
//        UserDefaults.standard.set(userID, forKey: "UserID")
        
        print(UserDefaults.standard.string(forKey: "Email"))
        print(UserDefaults.standard.string(forKey: "UserName"))
        print(UserDefaults.standard.string(forKey: "UserID"))
    }
    

}
