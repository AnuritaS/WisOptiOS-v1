//
//  GroupTableViewCell.swift
//  WisOpt
//
//  Created by ADT One on 25/09/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    //MARK: Properties

    var group_view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x476ae8)
        return view
    }()

    var group_label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.textColor = .white
        view.textAlignment = .center
        view.layer.cornerRadius = view.frame.width / 2
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return view
    }()
    var admin_view: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"medal")
        view.contentMode = .scaleAspectFit
        return view
    }()

    var countL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(rgb: 0x476ae8)
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 10)

        return view
    }()

    var indicatorL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1
        view.textColor = .blue
        view.textAlignment = .center
        view.font = UIFont(name: "HelveticaNeue", size: 14)

        return view
    }()

    var titleL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x000000)
        view.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true

        return view
    }()

    var messageL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x494949)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true

        return view
    }()

    var symbol: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"right")
        view.contentMode = .scaleAspectFit
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
        setShadows()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(group_view)
        group_view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        group_view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        group_view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        group_view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        group_view.layer.cornerRadius = 50 / 2

        group_view.addSubview(admin_view)
        admin_view.rightAnchor.constraint(equalTo: group_view.rightAnchor, constant: 3).isActive = true
        admin_view.centerYAnchor.constraint(equalTo: group_view.centerYAnchor, constant: 13).isActive = true
        admin_view.widthAnchor.constraint(equalToConstant: 15).isActive = true
        admin_view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        admin_view.layer.cornerRadius = 15 / 2

        addSubview(group_label)
        group_label.centerXAnchor.constraint(equalTo: group_view.centerXAnchor).isActive = true
        group_label.centerYAnchor.constraint(equalTo: group_view.centerYAnchor).isActive = true

        addSubview(symbol)
        symbol.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        symbol.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        symbol.heightAnchor.constraint(equalToConstant: 14).isActive = true
        symbol.widthAnchor.constraint(equalToConstant: 14).isActive = true

        addSubview(titleL)
        titleL.leftAnchor.constraint(equalTo: group_view.rightAnchor, constant: 10).isActive = true
        titleL.topAnchor.constraint(equalTo: topAnchor, constant: 18).isActive = true
        titleL.rightAnchor.constraint(equalTo: symbol.leftAnchor, constant: -35).isActive = true
        titleL.sizeToFit()

        addSubview(messageL)
        messageL.rightAnchor.constraint(equalTo: symbol.leftAnchor, constant: -35).isActive = true
        messageL.topAnchor.constraint(equalTo: titleL.bottomAnchor, constant: 10).isActive = true
        messageL.leftAnchor.constraint(equalTo: group_view.rightAnchor, constant: 10).isActive = true
        messageL.sizeToFit()

        addSubview(indicatorL)
        indicatorL.rightAnchor.constraint(equalTo: symbol.leftAnchor, constant: -5).isActive = true
        indicatorL.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorL.widthAnchor.constraint(equalToConstant: 30).isActive = true
        indicatorL.heightAnchor.constraint(equalToConstant: 30).isActive = true
        indicatorL.layer.cornerRadius = 30 / 2

        addSubview(countL)
        countL.centerYAnchor.constraint(equalTo: indicatorL.centerYAnchor).isActive = true
        countL.centerXAnchor.constraint(equalTo: indicatorL.centerXAnchor).isActive = true
        countL.widthAnchor.constraint(equalToConstant: 24).isActive = true
        countL.heightAnchor.constraint(equalToConstant: 24).isActive = true
        countL.layer.cornerRadius = 24 / 2

        addSubview(separator)
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true

    }

    func setShadows() {
        group_view.layer.shadowColor = UIColor.black.cgColor
        group_view.layer.shadowOpacity = 0.5
        group_view.layer.shadowRadius = 3
        group_view.layer.shadowOffset = CGSize(width: 2, height: 2)

    }

}

