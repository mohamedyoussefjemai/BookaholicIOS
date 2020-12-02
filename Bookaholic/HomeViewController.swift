//
//  HomeViewController.swift
//  Bookaholic
//
//  Created by wassim on 11/26/20.
//

import UIKit

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectionView1: UICollectionView!
    
    @IBOutlet weak var collectionView2: UICollectionView!
    var catlist = [UIImage(named:"1"),
                   UIImage(named:"2"),
                   UIImage(named:"3"),
                   UIImage(named:"4"),
                   UIImage(named:"5"),
                   UIImage(named:"6")]
    
    var data = [UIImage(named:"BookFair"),
                UIImage(named:"London Review of Books"),
                UIImage(named:"FairyTail"),
                UIImage(named:"Moonlight")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        collectionView1.delegate = self
        collectionView1.dataSource = self
        
        collectionView2.delegate = self
        collectionView2.dataSource = self
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView1{
            return catlist.count
        }
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView1 {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath)as! HomeCVC
            cell1.catimage.image = catlist[indexPath.row]
            return cell1
            
        } else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath)as! HomeCVC
            cell2.bookimage.image = data [indexPath.row]
            return cell2
        }
        
       
    }
    
   
}
