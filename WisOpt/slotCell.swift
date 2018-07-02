//
//  slotCell.swift
//  WisOpt
//
//  Created by WisOpt on 30/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit
import Charts

protocol subjectSlotRowDelegate: class {
    func slotCellTapped(subject: String, test: [Test], subject_name: String)
}

class slotCell: UICollectionViewCell {

    var slot_view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(rgb: 0xFF7682).cgColor
        return view
    }()

    var slot: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.textColor = UIColor(rgb: 0xFF7682)
        view.textAlignment = .center
        view.layer.cornerRadius = view.frame.width / 2
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension slotCell {
    func setupView() {
        addSubview(slot_view)
        slot_view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        slot_view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        slot_view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        slot_view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        slot_view.layer.cornerRadius = 50 / 2

        addSubview(slot)
        slot.centerXAnchor.constraint(equalTo: slot_view.centerXAnchor).isActive = true
        slot.centerYAnchor.constraint(equalTo: slot_view.centerYAnchor).isActive = true
    }

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                super.isSelected = true
                self.slot_view.backgroundColor = UIColor(rgb: 0xFF7682)
                self.slot.textColor = UIColor(rgb: 0xFFFFFF)
            } else {
                super.isSelected = false
                self.slot_view.backgroundColor = UIColor(rgb: 0xFFFFFF)
                self.slot.textColor = UIColor(rgb: 0xFF7682)
            }
        }

    }
}
