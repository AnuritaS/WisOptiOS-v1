//
//  CourseTableCell.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 12/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class CourseTableCell: UITableViewCell {
    //MARK: Properties

    @IBOutlet weak var slotBG: UIView!
    @IBOutlet weak var subjectN: UILabel!
    @IBOutlet weak var courseC: UILabel!
    @IBOutlet weak var facultyNI: UILabel!
    @IBOutlet weak var room_lab: UILabel!
    @IBOutlet weak var time_frm: UILabel!
    @IBOutlet weak var time_to: UILabel!
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var batch: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
}
