//
//  LastTopicView.swift
//  WisOpt
//
//  Created by WisOpt on 21/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//


import UIKit
import Charts

class LastTopicViewController: UIViewController {

    var percentage = Double()
    var dateData = [Dates]()

    var myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)

        return view
    }()

    lazy var subL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        view.textAlignment = .center
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)
        view.textColor = UIColor(rgb: 0x423F3C)
        return view
    }()

    var pieChart: PieChartView = {
        let view = PieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animate(xAxisDuration: 1.0, easingOption: .easeOutCirc)
        view.holeRadiusPercent = 0.8
        view.legend.enabled = false
        return view
    }()

    lazy var presentL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left

        return view
    }()

    lazy var totalL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left

        return view
    }()

    lazy var scodeL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left

        return view
    }()

    lazy var roomL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left
        view.text = "Room No: "
        return view
    }()

    lazy var facultyL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476AE8)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left
        view.text = "Faculty: "
        return view
    }()

    lazy var roomNoL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left

        return view
    }()

    lazy var facultyNameL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .left
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    lazy var topicL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x423F3C)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        view.textAlignment = .center
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)
        view.text = "Attendance Record"

        return view
    }()
    var separator: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)

        return view
    }()

    lazy var myTableView: UITableView = {
        let view = UITableView()
        //view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: min(300, view.contentSize.height))
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsetsMake(100, 0, 0, 100)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)
        return view
    }()

    var cancel: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName:"Cancel"), for: .normal)
        view.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()

        let absentPer = 100 - percentage
        Utils.setChart(pieChart: pieChart, dataPoints: ["Present", "Absent"], values: [percentage, absentPer], colors: Utils.attendance(percentage))
        myTableView.register(LastTopicCell.self, forCellReuseIdentifier: "topicCell")
    }

    @objc func pressButton(_ sender: Any) {
        print("pressed")
        dismiss(animated: true, completion: nil)
    }
}

extension LastTopicViewController {

    func setupView() {
        view.addSubview(myView)
        NSLayoutConstraint.activate([
            myView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            myView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            myView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            myView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -100)
        ])

        myView.addSubview(subL)
        NSLayoutConstraint.activate([
            subL.leftAnchor.constraint(equalTo: myView.leftAnchor),
            subL.rightAnchor.constraint(equalTo: myView.rightAnchor),
            subL.topAnchor.constraint(equalTo: myView.topAnchor),
            subL.heightAnchor.constraint(equalToConstant: 30)
        ])

        myView.addSubview(pieChart)
        NSLayoutConstraint.activate([
            pieChart.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            pieChart.topAnchor.constraint(equalTo: subL.bottomAnchor),
            pieChart.widthAnchor.constraint(equalToConstant: 110),
            pieChart.heightAnchor.constraint(equalToConstant: 110)
        ])

        myView.addSubview(scodeL)
        NSLayoutConstraint.activate([
            scodeL.leftAnchor.constraint(equalTo: pieChart.rightAnchor, constant: 2),
            scodeL.topAnchor.constraint(equalTo: subL.bottomAnchor, constant: 20),
            scodeL.heightAnchor.constraint(equalToConstant: 14)
        ])

        myView.addSubview(roomL)
        NSLayoutConstraint.activate([
            roomL.leftAnchor.constraint(equalTo: pieChart.rightAnchor, constant: 2),
            roomL.topAnchor.constraint(equalTo: scodeL.bottomAnchor, constant: 5),
            roomL.heightAnchor.constraint(equalToConstant: 14)
        ])

        myView.addSubview(roomNoL)
        NSLayoutConstraint.activate([
            roomNoL.leftAnchor.constraint(equalTo: roomL.rightAnchor, constant: 1),
            roomNoL.centerYAnchor.constraint(equalTo: roomL.centerYAnchor),
            roomNoL.heightAnchor.constraint(equalToConstant: 14)
        ])

        myView.addSubview(facultyL)
        NSLayoutConstraint.activate([
            facultyL.leftAnchor.constraint(equalTo: pieChart.rightAnchor, constant: 2),
            facultyL.topAnchor.constraint(equalTo: roomL.bottomAnchor, constant: 5),
            facultyL.heightAnchor.constraint(equalToConstant: 14)
        ])

        myView.addSubview(facultyNameL)
        NSLayoutConstraint.activate([
            facultyNameL.leftAnchor.constraint(equalTo: facultyL.rightAnchor, constant: 1),
            facultyNameL.centerYAnchor.constraint(equalTo: facultyL.centerYAnchor),
            facultyNameL.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -5)
        ])

        myView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leftAnchor.constraint(equalTo: pieChart.rightAnchor),
            separator.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            separator.topAnchor.constraint(equalTo: facultyL.bottomAnchor, constant: 5),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])

        myView.addSubview(presentL)
        NSLayoutConstraint.activate([
            presentL.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 5),
            presentL.leftAnchor.constraint(equalTo: pieChart.rightAnchor, constant: 2),
            presentL.heightAnchor.constraint(equalToConstant: 14)
        ])

        myView.addSubview(totalL)
        NSLayoutConstraint.activate([
            totalL.topAnchor.constraint(equalTo: presentL.bottomAnchor, constant: 5),
            totalL.leftAnchor.constraint(equalTo: pieChart.rightAnchor, constant: 2),
            totalL.heightAnchor.constraint(equalToConstant: 14)
        ])
        myView.addSubview(topicL)
        NSLayoutConstraint.activate([
            topicL.leftAnchor.constraint(equalTo: myView.leftAnchor),
            topicL.rightAnchor.constraint(equalTo: myView.rightAnchor),
            topicL.topAnchor.constraint(equalTo: totalL.bottomAnchor, constant: 10),
            topicL.heightAnchor.constraint(equalToConstant: 30)
        ])

        myView.addSubview(myTableView)
        NSLayoutConstraint.activate([
            myTableView.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            myTableView.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            myTableView.topAnchor.constraint(equalTo: topicL.bottomAnchor, constant: 10),
            myTableView.bottomAnchor.constraint(equalTo: myView.bottomAnchor)
        ])

        view.addSubview(cancel)
        NSLayoutConstraint.activate([
            cancel.topAnchor.constraint(equalTo: myView.bottomAnchor, constant: 20),
            cancel.heightAnchor.constraint(equalToConstant: 30),
            cancel.widthAnchor.constraint(equalToConstant: 30),
            cancel.centerXAnchor.constraint(equalTo: myView.centerXAnchor)
        ])

    }

}

extension LastTopicViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! LastTopicCell
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(rgb: 0xF0F0F1)
        } else {
            cell.contentView.backgroundColor = UIColor(rgb: 0xFFFFFF)
        }
        cell.dateL.text = dateData[indexPath.row].classDate
        cell.topicL.text = dateData[indexPath.row].topic ?? ""
        if let isPresent = dateData[indexPath.row].ispresent {
            cell.presentL.text = isPresent
            if isPresent == "Present" || isPresent == "present" {
                cell.presentL.textColor = UIColor(rgb: 0x476AE8)
            } else {
                cell.presentL.textColor = UIColor(rgb: 0xF6675C)
            }
        }
        return cell
    }
}

