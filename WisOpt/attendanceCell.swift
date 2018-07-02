//
//  attendanceCell.swift
//  WisOpt
//
//  Created by WisOpt on 06/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit
import Charts


protocol AttendanceRowDelegate: class {
    func cellTapped(dates: [Dates], percentage: Double, sub: String, slot: String, code: String, room: String, faculty: String, presentHr: Int, totalHr: Int)
}

class attendanceCell: UICollectionViewCell {

    var pieChart: PieChartView = {
        let view = PieChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animate(xAxisDuration: 1.0, easingOption: .easeOutCirc)
        view.holeRadiusPercent = 0.8
        view.legend.enabled = false

        return view
    }()

    lazy var scodeL: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(rgb: 0x476ae8)
        view.font = UIFont(name: "HelveticaNeue", size: 12)
        view.textAlignment = .center

        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(pieChart)
        NSLayoutConstraint.activate([
            pieChart.leftAnchor.constraint(equalTo: leftAnchor),
            pieChart.topAnchor.constraint(equalTo: topAnchor),
            pieChart.rightAnchor.constraint(equalTo: rightAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: 110)
        ])

        addSubview(scodeL)
        NSLayoutConstraint.activate([

            scodeL.centerXAnchor.constraint(equalTo: pieChart.centerXAnchor),
            scodeL.topAnchor.constraint(equalTo: pieChart.bottomAnchor),
            scodeL.heightAnchor.constraint(equalToConstant: 16)

        ])

    }

}
