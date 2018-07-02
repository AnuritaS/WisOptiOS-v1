//
//  RoomTableViewCell.swift
//  WisOpt
//
//  Created by ADT One on 12/10/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subtitleL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
