//
//  ScoreCell.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 20/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//


import UIKit
import PieCharts
import ChartLegends

class ScoreCell: UITableViewCell {

    var studentMarks = [Mark]()
    var studentTests = [Test]()
    weak var delegate: subjectSlotRowDelegate?
    var chartLegendsHeightAnchor: NSLayoutConstraint?

    var myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)

        return view
    }()

    lazy var titleL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476ae8)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        view.textAlignment = .center
        view.backgroundColor = UIColor(rgb: 0xF0F0F1)
        view.text = "Test Performance"
        return view
    }()

    var pieChart: PieChart = {
        let view = PieChart()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    var separator: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(rgb: 0xf5f5f5)

        return view
    }()

    lazy var subL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        setStyle(label: view)
        view.text = "SUBJECT"

        return view
    }()

    lazy var scodeL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        setStyle(label: view)
        view.text = "CODE"

        return view
    }()
    lazy var totalScoreL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        setStyle(label: view)

        return view
    }()

    var symbol: UIButton = {
        var view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName:"Union 2"), for: .normal)
        return view

    }()

    var chartLegends: ChartLegendsView = {
        var view = ChartLegendsView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()


    lazy var collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50), collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.showsHorizontalScrollIndicator = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.collection.register(slotCell.self, forCellWithReuseIdentifier: "slotCell")

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
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

        myView.addSubview(titleL)
        NSLayoutConstraint.activate([
            titleL.leftAnchor.constraint(equalTo: myView.leftAnchor),
            titleL.rightAnchor.constraint(equalTo: myView.rightAnchor),
            titleL.topAnchor.constraint(equalTo: myView.topAnchor),
            titleL.heightAnchor.constraint(equalToConstant: 40)
        ])

        myView.addSubview(pieChart)
        NSLayoutConstraint.activate([
            pieChart.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
            pieChart.topAnchor.constraint(equalTo: titleL.bottomAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: 120),
            pieChart.leftAnchor.constraint(equalTo: myView.leftAnchor),
            pieChart.rightAnchor.constraint(equalTo: myView.rightAnchor)
        ])
        pieChart.innerRadius = 35
        pieChart.outerRadius = 55
        pieChart.contentMode = .scaleAspectFit

        myView.addSubview(totalScoreL)
        NSLayoutConstraint.activate([
            totalScoreL.centerYAnchor.constraint(equalTo: pieChart.centerYAnchor),
            totalScoreL.centerXAnchor.constraint(equalTo: pieChart.centerXAnchor),
            totalScoreL.heightAnchor.constraint(equalToConstant: 16)
        ])
        pieChart.bringSubview(toFront: totalScoreL)

        myView.addSubview(chartLegends)
        NSLayoutConstraint.activate([
            chartLegends.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 10),
            chartLegends.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            chartLegends.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10)
        ])
        chartLegendsHeightAnchor = chartLegends.heightAnchor.constraint(equalToConstant: 60)
        chartLegendsHeightAnchor?.isActive = true


        myView.addSubview(scodeL)
        NSLayoutConstraint.activate([
            scodeL.topAnchor.constraint(equalTo: chartLegends.bottomAnchor, constant: 10),
            scodeL.centerXAnchor.constraint(equalTo: pieChart.centerXAnchor),
            scodeL.heightAnchor.constraint(equalToConstant: 16)

        ])

        myView.addSubview(subL)
        NSLayoutConstraint.activate([
            subL.topAnchor.constraint(equalTo: scodeL.bottomAnchor, constant: 10),
            subL.centerXAnchor.constraint(equalTo: pieChart.centerXAnchor),
            subL.heightAnchor.constraint(equalToConstant: 16)
        ])

        myView.addSubview(symbol)
        NSLayoutConstraint.activate([
            symbol.topAnchor.constraint(equalTo: subL.bottomAnchor, constant: 10),
            symbol.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            symbol.heightAnchor.constraint(equalToConstant: 14),
            symbol.widthAnchor.constraint(equalToConstant: 14)
        ])
        // symbol.addta

        myView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            separator.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            separator.topAnchor.constraint(equalTo: symbol.bottomAnchor, constant: 10),
            separator.heightAnchor.constraint(equalToConstant: 2)
        ])


        myView.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10),
            collection.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10),
            collection.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            collection.heightAnchor.constraint(equalToConstant: 50),
            collection.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -10)
        ])

    }

    func setStyle(label: UILabel) {
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .center
        label.textColor = UIColor(rgb: 0x476ae8)
    }

}

extension ScoreCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return studentMarks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotCell", for: indexPath) as! slotCell

        cell.slot.text = studentMarks[indexPath.row].slot
        if indexPath.row == 0 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left) //Add this line
            //  self.callDelegate()
            cell.isSelected = true

        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.callDelegate(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func callDelegate(indexPath: IndexPath) {
        if delegate != nil {
            delegate?.slotCellTapped(subject: studentMarks[indexPath.row].subject ?? "", test: studentMarks[indexPath.row].test!, subject_name: studentMarks[indexPath.row].subject_name ?? "")
        }
    }
}
