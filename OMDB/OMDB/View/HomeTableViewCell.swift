//
//  HomeTableViewCell.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//
import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnAdd: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
