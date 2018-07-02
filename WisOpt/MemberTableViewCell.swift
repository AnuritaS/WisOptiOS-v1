//
//  MemberTableViewCell.swift
//  WisOpt
//
//  Created by ADT One on 15/10/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var branchL: UILabel!
    @IBOutlet weak var backgroungCellView: UIView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var registrationNumberL: UILabel!
    @IBOutlet weak var yearL: UILabel!
    @IBOutlet weak var acceptB: UIButton!
    @IBOutlet weak var rejectB: UIButton!

    var onAcceptTapped: (() -> Void)? = nil
    var onRejectTapped: (() -> Void)? = nil

    var member: Member? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupView() {

        backgroungCellView.layer.masksToBounds = false
        backgroungCellView.layer.cornerRadius = 3.0
        backgroungCellView.layer.shadowColor = UIColor(rgb: 0x000000).cgColor
        backgroungCellView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backgroungCellView.layer.shadowRadius = 3
        backgroungCellView.layer.shadowOpacity = 0.5
    }

    //MARK: Actions
    @IBAction func acceptB(_ sender: UIButton) {
        if let onAcceptTapped = self.onAcceptTapped {
            onAcceptTapped()
        }
    }

    @IBAction func rejectB(_ sender: UIButton) {
        if let onRejectTapped = self.onRejectTapped {
            onRejectTapped()
        }
    }

}
