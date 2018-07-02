//
//  SettingsCell.swift
//  WisOpt
//
//  Created by WisOpt on 22/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    var photo_icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true

        return view
    }()

    var field: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.textColor = UIColor.gray
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        view.textAlignment = .left

        return view
    }()

    var value: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        // view.textColor = UIColor(rgb: 0x494949)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(photo_icon)
        photo_icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        photo_icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        photo_icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 34).isActive = true
        photo_icon.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true

        addSubview(field)
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 84).isActive = true
        field.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        field.widthAnchor.constraint(equalToConstant: 200).isActive = true
        field.sizeToFit()

        addSubview(value)
        value.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        value.topAnchor.constraint(equalTo: topAnchor, constant: 21).isActive = true
        value.leftAnchor.constraint(equalTo: leftAnchor, constant: 84).isActive = true
        value.sizeToFit()

        addSubview(separator)
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true

        addSubview(symbol)
        symbol.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        symbol.topAnchor.constraint(equalTo: topAnchor, constant: 23).isActive = true
        symbol.heightAnchor.constraint(equalToConstant: 14).isActive = true
        symbol.widthAnchor.constraint(equalToConstant: 14).isActive = true
    }
}
