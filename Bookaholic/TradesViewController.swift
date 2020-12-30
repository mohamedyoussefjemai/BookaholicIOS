//
//  TradesViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit

class TradesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  @IBAction func tradrec(){
    performSegue(withIdentifier : "traderecieved", sender: self)
    }
    @IBAction func tradsend(){
      performSegue(withIdentifier : "tradesended", sender: self)
      }

}
