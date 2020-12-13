//
//  HomeTableViewCell.swift
//  Bookaholic
//
//  Created by wassim on 12/13/20.
//

import UIKit
protocol btnincell {
    func onClick(index: Int)
    }
class HomeTableViewCell: UITableViewCell {
	
    
    @IBOutlet weak var heart: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bookname: UILabel!
    var cellDelegate : btnincell?
    var index: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

   @IBAction func addfav() {
        self.heart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cellDelegate?.onClick(index: index!.row)
    }
}
