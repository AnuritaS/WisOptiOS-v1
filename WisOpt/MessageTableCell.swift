//
//  MessageTableCell.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 26/11/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {

    var onReplyTapped: (() -> Void)? = nil
    var onSeenTapped: (() -> Void)? = nil

    lazy var userL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x494949)
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        view.textAlignment = .left
        view.textColor = UIColor(rgb: 0x000000)
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
    lazy var replyL: UIButton = {
        var view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xffffff)
        view.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        view.setTitle("Reply", for: .normal)
        view.setTitleColor(UIColor(rgb: 0x476ae8), for: .normal)
        view.layer.borderColor = UIColor.clear.cgColor

        return view
    }()

    var reply_symbol: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"reply")
        view.contentMode = .scaleAspectFit
        return view

    }()

    lazy var seenL: UIButton = {
        var view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xffffff)
        view.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        view.setTitle("Seen", for: .normal)
        view.setTitleColor(UIColor(rgb: 0x476ae8), for: .normal)
        view.layer.borderColor = UIColor.clear.cgColor

        return view
    }()

    var seen_symbol: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"seen")
        view.contentMode = .scaleAspectFit
        return view

    }()
    var countL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(rgb: 0xE50000)
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        return view
    }()
    var separator: UIView = {

        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xf5f5f5)

        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()

        seenL.addTarget(self, action: #selector(openAcknowledgement(_:)), for: .touchUpInside)
        replyL.addTarget(self, action: #selector(openReply(_:)), for: .touchUpInside)

    }

    @objc func openReply(_ sender: UIButton) {
        if let onReplyTapped = self.onReplyTapped {
            onReplyTapped()
        }
    }

    @objc func openAcknowledgement(_ sender: UIButton) {
        if let onSeenTapped = self.onSeenTapped {
            onSeenTapped()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {

        addSubview(timeL)
        timeL.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        timeL.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        timeL.sizeToFit()

        addSubview(userL)
        userL.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        userL.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userL.rightAnchor.constraint(equalTo: timeL.leftAnchor, constant: -20).isActive = true
        userL.sizeToFit()

        addSubview(messageL)
        messageL.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        messageL.topAnchor.constraint(equalTo: userL.bottomAnchor, constant: 5).isActive = true
        messageL.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        messageL.sizeToFit()

        addSubview(replyL)
        replyL.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        replyL.topAnchor.constraint(equalTo: messageL.bottomAnchor, constant: 10).isActive = true
        replyL.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        replyL.widthAnchor.constraint(equalToConstant: 50).isActive = true
        replyL.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(reply_symbol)
        reply_symbol.rightAnchor.constraint(equalTo: replyL.leftAnchor, constant: -5).isActive = true
        reply_symbol.centerYAnchor.constraint(equalTo: replyL.centerYAnchor).isActive = true
        reply_symbol.heightAnchor.constraint(equalToConstant: 20).isActive = true
        reply_symbol.widthAnchor.constraint(equalToConstant: 20).isActive = true

        addSubview(countL)
        countL.rightAnchor.constraint(equalTo: reply_symbol.leftAnchor, constant: -5).isActive = true
        countL.centerYAnchor.constraint(equalTo: reply_symbol.centerYAnchor).isActive = true
        countL.widthAnchor.constraint(equalToConstant: 20).isActive = true
        countL.heightAnchor.constraint(equalToConstant: 20).isActive = true
        countL.layer.cornerRadius = 20 / 2

        addSubview(seen_symbol)
        seen_symbol.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        seen_symbol.centerYAnchor.constraint(equalTo: reply_symbol.centerYAnchor).isActive = true
        seen_symbol.heightAnchor.constraint(equalToConstant: 20).isActive = true
        seen_symbol.widthAnchor.constraint(equalToConstant: 20).isActive = true

        addSubview(seenL)
        seenL.leftAnchor.constraint(equalTo: seen_symbol.rightAnchor, constant: 5).isActive = true
        seenL.centerYAnchor.constraint(equalTo: replyL.centerYAnchor).isActive = true
        seenL.widthAnchor.constraint(equalToConstant: 50).isActive = true
        seenL.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(separator)
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true

    }


}

class MessageImageCell: MessageTableCell {


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

        replyL.topAnchor.constraint(equalTo: imageIV.bottomAnchor, constant: 10).isActive = true
    }

}

class MessageDocCell: MessageImageCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupImageView()
        setupDocView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDocView() {


        imageIV.widthAnchor.constraint(equalToConstant: 285).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 69).isActive = true


    }

}

class MessageHeaderCell: UITableViewCell {

    lazy var headerL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0xffffff)
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
        view.textAlignment = .center
        view.backgroundColor = UIColor(rgb: 0x476ae8)
        view.layer.masksToBounds = true
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

        addSubview(headerL)
        headerL.heightAnchor.constraint(equalToConstant: 15).isActive = true
        headerL.widthAnchor.constraint(equalToConstant: 80).isActive = true
        headerL.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerL.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerL.sizeToFit()

        headerL.layer.cornerRadius = 6

    }

}
