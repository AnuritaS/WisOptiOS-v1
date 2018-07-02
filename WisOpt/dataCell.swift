//
//  dataCell.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 14/02/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class dataCell: UITableViewCell {

    var stud: Bool?

    lazy var myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xffffff)

        return view
    }()
    var profile_view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)

        return view
    }()

    //Name initials
    var profile: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = view.frame.width / 2

        return view
    }()

    //Name
    var name: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .center
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        view.minimumScaleFactor = 0.2
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    //Registration number
    var reg: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .center
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 14)

        return view
    }()

    //Email
    var email: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .center
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 13)
        view.minimumScaleFactor = 0.2
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        return view
    }()

    //Profession
    var profImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var profL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 10)
        view.textAlignment = .left
        view.text = "Profession"
        return view
    }()

    var prof: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .left
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)

        return view
    }()
    //Department
    var deptImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"department")

        return view
    }()

    lazy var deptL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 10)
        view.textAlignment = .left
        view.text = "Department"
        return view
    }()

    var dept: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .left
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    //Year
    var yearImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"year")

        return view
    }()

    lazy var yearL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 10)
        view.textAlignment = .left
        view.text = "Year"

        return view
    }()
    var year: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .left
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)

        return view
    }()

    //Faculty Advisor
    var advisorImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"class-incharge")

        return view
    }()

    lazy var advisorL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 10)
        view.textAlignment = .left
        view.text = "Class Incharge"
        return view
    }()

    var advisor: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .left
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    //Year coordinator
    var coordinatorImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName:"year-coordinator")
        return view
    }()

    lazy var coordinatorL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 10)
        view.textAlignment = .left
        view.text = "Year Coordinator"
        return view
    }()

    var coordinator: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.textAlignment = .left
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    var separator: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)

        return view
    }()

    var separator2: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)

        return view
    }()

    //Attendance Module


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        stud = (Session.getString(forKey: Session.PROFESSION) == "Student")
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.contentView.backgroundColor = UIColor(rgb: 0xFFFFFF)
        DispatchQueue.main.async() {
            self.yearImg.isHidden = true
            self.yearL.isHidden = true
            self.year.isHidden = true
            self.advisorImg.isHidden = true
            self.advisorL.isHidden = true
            self.advisor.isHidden = true
            self.coordinatorImg.isHidden = true
            self.coordinatorL.isHidden = true
            self.coordinator.isHidden = true
            self.profile.image = #imageLiteral(resourceName:"profile_round")

        }
        //Profile View
        addSubview(myView)
        myView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        myView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        myView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        myView.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowRadius = 5
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)

        addSubview(profile_view)
        profile_view.topAnchor.constraint(equalTo: myView.topAnchor, constant: -30).isActive = true
        profile_view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profile_view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profile_view.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        profile_view.layer.cornerRadius = 60 / 2
        profile_view.layer.shadowColor = UIColor.black.cgColor
        profile_view.layer.shadowOpacity = 0.2
        profile_view.layer.shadowRadius = 3
        profile_view.layer.shadowOffset = CGSize(width: 2, height: 2)

        profile_view.addSubview(profile)
        profile.centerXAnchor.constraint(equalTo: profile_view.centerXAnchor).isActive = true
        profile.centerYAnchor.constraint(equalTo: profile_view.centerYAnchor).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 30).isActive = true

        myView.addSubview(name)
        name.topAnchor.constraint(equalTo: profile_view.bottomAnchor, constant: 5).isActive = true
        name.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10).isActive = true
        name.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10).isActive = true
        name.sizeToFit()

        myView.addSubview(reg)
        reg.topAnchor.constraint(equalTo: name.topAnchor, constant: 20).isActive = true
        reg.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10).isActive = true
        reg.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10).isActive = true
        reg.sizeToFit()

        myView.addSubview(email)
        email.topAnchor.constraint(equalTo: reg.topAnchor, constant: 20).isActive = true
        email.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10).isActive = true
        email.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10).isActive = true
        email.sizeToFit()

        myView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            separator.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            separator.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 5),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        myView.addSubview(profImg)
        NSLayoutConstraint.activate([
            profImg.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 7),
            profImg.heightAnchor.constraint(equalToConstant: 20),
            profImg.widthAnchor.constraint(equalToConstant: 20),
            profImg.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 30)
        ])

        myView.addSubview(profL)
        NSLayoutConstraint.activate([
            profL.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
            profL.leftAnchor.constraint(equalTo: profImg.rightAnchor, constant: 10),
        ])
        profL.sizeToFit()

        myView.addSubview(prof)
        NSLayoutConstraint.activate([
            prof.topAnchor.constraint(equalTo: profL.bottomAnchor, constant: 2),
            prof.leftAnchor.constraint(equalTo: profL.leftAnchor),
        ])
        prof.sizeToFit()


        myView.addSubview(yearImg)
        NSLayoutConstraint.activate([
            yearImg.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 7),
            yearImg.heightAnchor.constraint(equalToConstant: 20),
            yearImg.widthAnchor.constraint(equalToConstant: 20),
            yearImg.centerXAnchor.constraint(equalTo: myView.centerXAnchor, constant: 30)
        ])

        myView.addSubview(yearL)
        NSLayoutConstraint.activate([
            yearL.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
            yearL.leftAnchor.constraint(equalTo: yearImg.rightAnchor, constant: 10)
        ])
        yearL.sizeToFit()

        myView.addSubview(year)
        NSLayoutConstraint.activate([
            year.topAnchor.constraint(equalTo: yearL.bottomAnchor, constant: 2),
            year.leftAnchor.constraint(equalTo: yearL.leftAnchor),
        ])
        year.sizeToFit()

        myView.addSubview(deptImg)
        NSLayoutConstraint.activate([
            deptImg.topAnchor.constraint(equalTo: profImg.bottomAnchor, constant: 22),
            deptImg.heightAnchor.constraint(equalToConstant: 20),
            deptImg.widthAnchor.constraint(equalToConstant: 20),
            deptImg.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 30)
        ])

        myView.addSubview(deptL)
        NSLayoutConstraint.activate([
            deptL.topAnchor.constraint(equalTo: profImg.bottomAnchor, constant: 20),
            deptL.leftAnchor.constraint(equalTo: deptImg.rightAnchor, constant: 10)
        ])
        deptL.sizeToFit()

        myView.addSubview(dept)
        NSLayoutConstraint.activate([
            dept.topAnchor.constraint(equalTo: deptL.bottomAnchor, constant: 2),
            dept.leftAnchor.constraint(equalTo: deptL.leftAnchor),
        ])
        dept.sizeToFit()

        myView.addSubview(separator2)
        NSLayoutConstraint.activate([
            separator2.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            separator2.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            separator2.topAnchor.constraint(equalTo: deptImg.bottomAnchor, constant: 10),
            separator2.heightAnchor.constraint(equalToConstant: 2)
        ])

        myView.addSubview(advisorImg)
        NSLayoutConstraint.activate([
            advisorImg.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),
            advisorImg.heightAnchor.constraint(equalToConstant: 20),
            advisorImg.widthAnchor.constraint(equalToConstant: 20),
            advisorImg.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 30)
        ])

        myView.addSubview(advisorL)
        NSLayoutConstraint.activate([
            advisorL.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 5),
            advisorL.leftAnchor.constraint(equalTo: advisorImg.rightAnchor, constant: 10),
        ])
        advisorL.sizeToFit()

        myView.addSubview(advisor)
        NSLayoutConstraint.activate([
            advisor.topAnchor.constraint(equalTo: advisorL.bottomAnchor),
            advisor.leftAnchor.constraint(equalTo: advisorL.leftAnchor),
            advisor.rightAnchor.constraint(equalTo: myView.centerXAnchor, constant: -10),
            advisor.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -10)
        ])
        advisor.sizeToFit()

        myView.addSubview(coordinatorImg)
        NSLayoutConstraint.activate([
            coordinatorImg.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),
            coordinatorImg.heightAnchor.constraint(equalToConstant: 20),
            coordinatorImg.widthAnchor.constraint(equalToConstant: 20),
            coordinatorImg.centerXAnchor.constraint(equalTo: myView.centerXAnchor, constant: 30)
        ])

        myView.addSubview(coordinatorL)
        NSLayoutConstraint.activate([
            coordinatorL.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 5),
            coordinatorL.leftAnchor.constraint(equalTo: coordinatorImg.rightAnchor, constant: 10)
        ])
        coordinatorL.sizeToFit()

        myView.addSubview(coordinator)
        NSLayoutConstraint.activate([
            coordinator.topAnchor.constraint(equalTo: coordinatorL.bottomAnchor),
            coordinator.leftAnchor.constraint(equalTo: coordinatorL.leftAnchor),
            coordinator.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            coordinator.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -10)
        ])
        coordinator.sizeToFit()

    }

}

