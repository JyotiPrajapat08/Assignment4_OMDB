//
//  FavTableViewCell.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
