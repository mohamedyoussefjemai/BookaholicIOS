//
//  MenuViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func msg(){
        performSegue(withIdentifier: "msg", sender: self)
    }
    @IBAction func trades(){
        performSegue(withIdentifier: "trades", sender: self)
    }
    
    @IBAction func sales(){
        performSegue(withIdentifier: "sales", sender: self)
    }
}
