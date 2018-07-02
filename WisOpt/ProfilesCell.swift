//
//  ProfilesCell.swift
//  WisOpt
//
//  Created by WisOpt on 07/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//


import UIKit
import Alamofire
import Charts

class ProfilesCell: UITableViewCell {

    var attnd = [Attendance]()
    weak var delegate: AttendanceRowDelegate?

    lazy var myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xffffff)

        return view
    }()

    lazy var subL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476ae8)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        view.textAlignment = .center
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)
        view.text = "Attendance"
        return view
    }()

    lazy var collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.layer.masksToBounds = false
        view.backgroundColor = UIColor(rgb: 0xffffff)
        return view
    }()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.collection.register(attendanceCell.self, forCellWithReuseIdentifier: "attendanceCell")
        setupView()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.contentView.backgroundColor = UIColor(rgb: 0xFFFFFF)

        addSubview(myView)
        NSLayoutConstraint.activate([
            myView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            myView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            myView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            myView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowRadius = 5
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)

        myView.addSubview(subL)
        NSLayoutConstraint.activate([
            subL.leftAnchor.constraint(equalTo: myView.leftAnchor),
            subL.rightAnchor.constraint(equalTo: myView.rightAnchor),
            subL.topAnchor.constraint(equalTo: myView.topAnchor),
            subL.heightAnchor.constraint(equalToConstant: 40)
        ])


        addSubview(collection)
        NSLayoutConstraint.activate([
            collection.leftAnchor.constraint(equalTo: myView.leftAnchor),
            collection.rightAnchor.constraint(equalTo: myView.rightAnchor),
            collection.topAnchor.constraint(equalTo: subL.bottomAnchor),
            collection.bottomAnchor.constraint(equalTo: myView.bottomAnchor)
        ])

    }

}

extension ProfilesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attnd.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attendanceCell", for: indexPath) as! attendanceCell

        cell.scodeL.text = "\(String(describing: self.attnd[indexPath.row].slotName ?? "")) - \(String(describing: self.attnd[indexPath.row].subjectCode ?? ""))"
        let presentPer = self.attnd[indexPath.row].percentage ?? 0.0
        let absentPer = 100 - presentPer
        Utils.setChart(pieChart: cell.pieChart, dataPoints: ["Present", "Absent"], values: [presentPer, absentPer], colors: Utils.attendance(presentPer))
        cell.pieChart.centerText = "\(presentPer)%"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.cellTapped(dates: self.attnd[indexPath.row].dates ?? [], percentage: self.attnd[indexPath.row].percentage ?? 0.0, sub: self.attnd[indexPath.row].subjectName ?? "", slot: self.attnd[indexPath.row].slotName ?? "", code: self.attnd[indexPath.row].subjectCode ?? "", room: self.attnd[indexPath.row].room ?? "", faculty: self.attnd[indexPath.row].facultyName ?? "", presentHr: self.attnd[indexPath.row].presentHours ?? 0, totalHr: self.attnd[indexPath.row].totalHours ?? 0)
        }
        print(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let yourWidth = collectionView.bounds.width / 3.0
        let yourHeight = collectionView.bounds.height / 4.0 - 20

        return CGSize(width: yourWidth, height: yourHeight)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
