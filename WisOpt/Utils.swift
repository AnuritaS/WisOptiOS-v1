//
//  Utils.swift
//  WisOpt
//
//  Created by ADT One on 24/09/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit
import Charts
import FirebaseMessaging

class Utils {
    static var stud = Bool()
    static let BASE_URL = "https://www.wisopt.com/"
    //test
    //static let BASE_URL = "http://13.127.34.159/"

    static let SUPPORTED_DOCUMENT_TYPES = ["jpg", "jpeg", "png", "JPG", "JPEG", "PNG", "pdf", "xls",
                                           "xlsx", "txt", "ppt", "pptx", "doc", "docx", "PDF", "XLS", "XLSX",
                                           "TXT", "PPT", "PPTX", "DOC", "DOCX"]

    static func getExtension(url: String) -> String {
        var index = url.lastIndexOf(".")!
        index = url.index(index, offsetBy: 1)

        let xt = url[index..<url.endIndex]
        return String(xt)
    }

    static func isSupportedDocumentType(ext: String) -> Bool {
        return SUPPORTED_DOCUMENT_TYPES.contains(ext)
    }

    static func showAlert(title: String, message: String, presenter: UIViewController) {
        // create the alert
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }

    static func showAlertWithAction(title: String, message: String, presenter: UIViewController) {
        // create the alert
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in
            if (action.style == .default) {
                if let navController = presenter.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }))

        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }

    static func setChart(pieChart: PieChartView, dataPoints: [String], values: [Double], colors: [UIColor]) {

        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i])
            dataEntries.append(dataEntry)
        }

        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: nil)
        pieChartDataSet.drawValuesEnabled = false
        //occupy whole frame
        // pieChartDataSet.selectionShift = 0
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueTextColor(.black)

        var chartColors: [UIColor] = []

        for i in 0..<dataPoints.count {
            let color = colors[i]
            chartColors.append(color)
        }

        pieChart.data = pieChartData
        pieChartDataSet.colors = chartColors


        pieChart.noDataText = "No data available"
        pieChart.chartDescription?.text = ""
        pieChart.isUserInteractionEnabled = false
    }

    static func attendance(_ percentage: Double) -> [UIColor] {
        var color = [UIColor]()
        if percentage < 75.00 {
            color = [UIColor(rgb: 0xF6675c), UIColor(rgb: 0xFCD4D1)]
        } else if percentage >= 75 && percentage < 80.00 {
            color = [UIColor(rgb: 0xFFD47C), UIColor(rgb: 0xFFF3DD)]
        } else {
            color = [UIColor(rgb: 0x6DE09C), UIColor(rgb: 0xD9F7E5)]
        }
        return color
    }

    static func getCurrentTime() -> Int {
        let currentDateTime = Date()

        // get the user's calendar
        let userCalendar = Calendar.current

        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]

        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        var timeHour = (dateTimeComponents.hour)

        return timeHour!
    }

    static func subscribeToTopics() {
        if Messaging.messaging().fcmToken != nil {
            if Session.getString(forKey: Session.PROFESSION) == "Student" {
                Messaging.messaging().subscribe(toTopic: "SRM")
                Messaging.messaging().subscribe(toTopic: "Student")
            } else if Session.getString(forKey: Session.PROFESSION) == "Professor" {
                Messaging.messaging().subscribe(toTopic: "SRM")
                Messaging.messaging().subscribe(toTopic: "Professor")
            }
        }
    }
}
