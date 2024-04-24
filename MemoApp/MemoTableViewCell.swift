//
//  MemoTableViewCell.swift
//  MemoApp
//
//  Created by Celes Augustus on 4/24/24.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCriticality: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
