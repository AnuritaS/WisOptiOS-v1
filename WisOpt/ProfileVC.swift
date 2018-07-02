//
//  ProfileVC.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 29/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    //MARK: Properties

    var attnd = [Attendance]()
    var userData: UserData?
    var details: Detail?
    var studentMarks = [Mark]()
    var studentTests = [Test]()
    var scode = String()
    var dates = [Dates]()
    var subject = String()
    var percentage = Double()
    var slot = String()
    var presentHr = Int()
    var totalHr = Int()
    var room = String()
    var faculty = String()

    lazy var settings: UIBarButtonItem = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName:"settings"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(openSettings(_:)), for: .touchUpInside)
        let view = UIBarButtonItem(customView: btn)

        return view
    }()

    lazy var myTableView: UITableView = {
        let view = UITableView()
        //view.frame = UIEdgeInsetsMake(10, 0, 10, 0)
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsetsMake(100, 0, 0, 100)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor(rgb: 0xffffff)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(rgb: 0xffffff)
        self.myTableView.register(dataCell.self, forCellReuseIdentifier: "dataCell")
        self.myTableView.register(ProfilesCell.self, forCellReuseIdentifier: "profilesTableCell")
        self.myTableView.register(ScoreCell.self, forCellReuseIdentifier: "scoreCell")


        setupView()
        self.getAttendance()
        self.f()

    }

    func setupView() {

        self.navigationItem.setRightBarButton(settings, animated: true)

        view.addSubview(myTableView)
        NSLayoutConstraint.activate([
            myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            myTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            myTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])

    }

    @objc func openSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "SettingsVC", sender: self)
    }

    func f() {

        if 17...18 ~= Utils.getCurrentTime() {
            if (userData?.profession == "Student") {
                Utils.showAlertWithAction(title: "Attendance", message: "Attendance is updating", presenter: self)
            }
        }
    }
}
