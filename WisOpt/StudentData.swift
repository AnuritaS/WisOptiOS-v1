//
//  StudentData.swift
//  WisOpt
//
//  Created by WisOpt on 06/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import NVActivityIndicatorView
import PieCharts

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prof = Constant().getProfession()
        if (userData?.profession == "Professor") || (prof == "Professor") {
            return 1
        }
        return 3

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var profession = ""
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! dataCell
            cell.selectionStyle = .none

            if (self.userData?.gender == "Female") {
                cell.profile.image = #imageLiteral(resourceName:"female_image")
            } else {
                cell.profile.image = #imageLiteral(resourceName:"male_image")
            }

            profession = self.userData?.profession ?? ""
            cell.name.text = self.userData?.name ?? ""
            cell.reg.text = self.userData?.regId ?? ""
            cell.dept.text = self.userData?.department ?? ""
            cell.email.text = self.userData?.email ?? ""
            cell.prof.text = profession


            if (profession == "Professor") {
                cell.profImg.image = #imageLiteral(resourceName:"professor")
            } else {
                cell.profImg.image = #imageLiteral(resourceName:"graduate-hat")
                cell.year.text = self.userData?.year ?? ""
                cell.advisor.text = "\(self.details?.classInchargeName ?? "")-\(self.details?.classInchargeId ?? "")"
                cell.coordinator.text = "\(self.details?.yearCoordinatorName ?? "")-\(self.details?.yearCoordinatorId ?? "")"
                cell.yearImg.isHidden = false
                cell.yearL.isHidden = false
                cell.year.isHidden = false
                cell.advisorImg.isHidden = false
                cell.advisorL.isHidden = false
                cell.advisor.isHidden = false
                cell.coordinatorImg.isHidden = false
                cell.coordinatorL.isHidden = false
                cell.coordinator.isHidden = false
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilesTableCell") as! ProfilesCell
            cell.selectionStyle = .none

            cell.attnd = self.attnd
            cell.delegate = self
            cell.collection.reloadData()

            return cell

        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreCell

            cell.studentMarks = self.studentMarks
            cell.studentTests = self.studentTests
            cell.delegate = self
            cell.collection.reloadData()
            cell.selectionStyle = .none

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if #available(iOS 11, *) {
            if indexPath.row == 1 {
                return (CGFloat(attnd.count) * 50) + 50
            }
            return UITableViewAutomaticDimension
        } else {
            if indexPath.row == 0 || indexPath.row == 2 {
                return 330
            }
            if indexPath.row == 1 {
                return 500
            }
            return UITableViewAutomaticDimension
        }

    }

    func reloadChart(aData: [Attendance], uData: UserData, dData: Detail, mData: [Mark]) {
        DispatchQueue.main.async {
            print("Refreshing data")
            self.attnd = aData
            self.userData = uData
            self.details = dData
            self.studentMarks = mData

            self.myTableView.reloadData()
        }
    }
}

extension ProfileVC: AttendanceRowDelegate, subjectSlotRowDelegate {
    func slotCellTapped(subject: String, test: [Test], subject_name: String) {
        var colors = [UIColor(rgb: 0x43403C), UIColor(rgb: 0xF0F0F1), UIColor(rgb: 0xFF7682)]
        var pieModal = [PieSliceModel]()
        var testTypes = [(text: String, color: UIColor)]()
        var testScores = [Double]()
        var testTotalMarks = [Double]()
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = myTableView.cellForRow(at: indexPath) as! ScoreCell
        cell.pieChart.models = pieModal
        cell.subL.text = subject_name
        cell.scodeL.text = subject
        for singleTest in 0..<test.count {
            print("testt", test.count)
            testTypes.append((text: test[singleTest].type ?? "", color: colors[singleTest]))
            testScores.append(Double(test[singleTest].score ?? "") ?? 0.0)
            testTotalMarks.append(Double(test[singleTest].totalMarks ?? "") ?? 0.0)
            pieModal.append(PieSliceModel(value: Double(test[singleTest].score ?? "") ?? 0.0, color: colors[singleTest]))
        }

        //  Utils.setChart(pieChart: cell.pieChart, dataPoints: testTypes, values:testScores , colors: colors)
        print("pieee", pieModal.count)
        cell.pieChart.models = pieModal

        let totalOfTestScore = testScores.reduce(0, +)
        let totalOfTotalMarks = testTotalMarks.reduce(0, +)
        cell.totalScoreL.text = "\(totalOfTestScore)/\(totalOfTotalMarks)"
        if testTypes.count > 2 {
            cell.chartLegendsHeightAnchor?.constant = CGFloat(testTypes.count * 20)
        }
        cell.chartLegends.setLegends(.circle(radius: 7), testTypes)
        view.layoutIfNeeded()

    }

    func cellTapped(dates: [Dates], percentage: Double, sub: String, slot: String, code: String, room: String, faculty: String, presentHr: Int, totalHr: Int) {
        //code for navigation
        self.dates = dates
        self.subject = sub
        self.scode = code
        self.percentage = percentage
        self.slot = slot
        self.room = room
        self.faculty = faculty
        self.presentHr = presentHr
        self.totalHr = totalHr
        performSegue(withIdentifier: "segueForPopup", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //get a reference to the destination view controller
        if (segue.identifier == "segueForPopup") {
            let popOverVC = UIStoryboard(name: "ProfileVC", bundle: nil).instantiateViewController(withIdentifier: "popUpVC") as! LastTopicViewController
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popOverVC.dateData = self.dates
            popOverVC.percentage = Double(self.percentage)
            popOverVC.subL.text = self.subject
            popOverVC.scodeL.text = "\(self.slot) - \(self.scode)"
            popOverVC.roomNoL.text = self.room
            popOverVC.facultyNameL.text = self.faculty
            popOverVC.presentL.text = "Attended Hours: \(self.presentHr)"
            popOverVC.totalL.text = "Conducted Hours: \(self.totalHr)"
            tabBarController?.present(popOverVC, animated: true)
        }
    }

    func getAttendance() {

        let u_id = Session.getInteger(forKey: Session.ID)
        let tc = Session.getString(forKey: Session.TOKEN_CODE)

        let url = URL(string: Utils.BASE_URL + "v2/attendance")!
        let param: [String: String] = ["userId": "\(u_id)", "token": "\(tc)"]
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    //print("Request: \(String(describing: response.request))")   // original url request
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    switch response.result {
                    case .success:

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)") // original server data as UTF8 string

                            let att = Attendance(JSONString: utf8Text)
                            let code = att?.status
                            if code == "success" {
                                print("Get attendance data successfully!")
                                self.reloadChart(aData: (att?.attendance) ?? [], uData: (att?.userData)!, dData: (att?.details)!, mData: (att?.marks) ?? [])
                            } else {
                                print("Unsuccessfull in getting attendance data!")
                            }
                        }

                    case .failure:
                        print("Error Ocurred in attendance data!")

                    }
                }
    }


}


