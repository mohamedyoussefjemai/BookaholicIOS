//
//  SalesViewController.swift
//  Bookaholic
//
//  Created by wassim on 12/29/20.
//

import UIKit

class SalesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func sale(){
      performSegue(withIdentifier : "sale", sender: self)
      }
      @IBAction func buy(){
        performSegue(withIdentifier :"buy", sender: self)
        }

  

}
