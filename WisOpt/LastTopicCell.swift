//
//  LastTopicCell.swift
//  WisOpt
//
//  Created by WisOpt on 21/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class LastTopicCell: UITableViewCell {

    lazy var dateL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        view.textAlignment = .left

        return view
    }()

    lazy var topicL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    lazy var presentL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        view.textAlignment = .left
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(dateL)
        NSLayoutConstraint.activate([
            dateL.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateL.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            dateL.heightAnchor.constraint(equalToConstant: 16)
        ])

        addSubview(topicL)
        NSLayoutConstraint.activate([
            topicL.topAnchor.constraint(equalTo: dateL.bottomAnchor, constant: 5),
            topicL.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            topicL.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            topicL.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        addSubview(presentL)
        NSLayoutConstraint.activate([
            presentL.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            presentL.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            presentL.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
