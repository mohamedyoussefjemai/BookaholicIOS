//
//  ViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/11/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var spinner:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
    }
   
    @IBAction func nextButton(){
        let vc=storyboard?.instantiateViewController(identifier: "login_VC")as!LoginViewController
        present(vc, animated: true)
        
    }
}

