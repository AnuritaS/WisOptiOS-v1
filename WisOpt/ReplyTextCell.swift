//
//  ReplyTextCell.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 06/12/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class ReplyTextCell: UITableViewCell {

    lazy var userL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x494949)
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        view.textAlignment = .left
        view.textColor = UIColor(rgb: 0x000000)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    lazy var messageL: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x494949)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        view.textAlignment = .left
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = UIColor(rgb: 0xECEFF1)

        return view
    }()

    lazy var timeL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0xb4b4b4)
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        view.textAlignment = .right
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

        addSubview(userL)
        userL.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        userL.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userL.sizeToFit()

        addSubview(messageL)
        messageL.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        messageL.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        messageL.topAnchor.constraint(equalTo: userL.bottomAnchor, constant: 5).isActive = true
        messageL.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        messageL.sizeToFit()

        messageL.layer.cornerRadius = 5

        addSubview(timeL)
        timeL.rightAnchor.constraint(equalTo: messageL.rightAnchor).isActive = true
        timeL.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        timeL.sizeToFit()
        userL.rightAnchor.constraint(equalTo: timeL.leftAnchor, constant: -20).isActive = true

    }

}

class ReplyImageCell: ReplyTextCell {


    var imageIV: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true

        return view

    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupImageView() {
        addSubview(imageIV)
        imageIV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageIV.topAnchor.constraint(equalTo: userL.bottomAnchor, constant: 10).isActive = true
        imageIV.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 315).isActive = true
        imageIV.image = #imageLiteral(resourceName:"logo")

        messageL.topAnchor.constraint(equalTo: imageIV.bottomAnchor, constant: 10).isActive = true
    }

}

class ReplyDocCell: ReplyTextCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupDocView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDocView() {


        messageL.widthAnchor.constraint(equalToConstant: 285).isActive = true
        messageL.heightAnchor.constraint(equalToConstant: 69).isActive = true


    }

}

