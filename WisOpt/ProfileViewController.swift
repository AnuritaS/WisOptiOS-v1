//
//  ProfileVC.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 29/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import NVActivityIndicatorView


class ProfileViewController: UIViewController {
    //MARK: Properties
    var studentId = Int()
    var attnd = [Attendance]()
    var userData: UserData?
    var details: Detail?
    var scode = String()
    var dates = [Dates]()
    var subject = String()
    var percentage = Double()
    var slot = String()
    var presentHr = Int()
    var totalHr = Int()
    var room = String()
    var faculty = String()

    lazy var myTableView: UITableView = {
        let view = UITableView()

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
        self.getStudentData()
        self.f()

    }

    func setupView() {

        view.addSubview(myTableView)
        NSLayoutConstraint.activate([
            myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            myTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            myTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])

    }


    func f() {

        if 17...18 ~= Utils.getCurrentTime() {
            Utils.showAlertWithAction(title: "Attendance", message: "Your attendance is updating", presenter: self)

        }
    }


    func getStudentData() {
        let u_id = Session.getInteger(forKey: Session.ID)
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        //print("STUDENT", self.studentId, u_id)
        let url = URL(string: Utils.BASE_URL + "v2/studentdata")!
        let param: [String: String] = ["id": "\(u_id)", "token": "\(tc)", "studentId": "\(self.studentId)"]
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    //print("Request: \(String(describing: response.request))")   // original url request
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    switch response.result {
                    case .success:

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            //print("Data: \(utf8Text)") // original server data as UTF8 string

                            let att = Attendance(JSONString: utf8Text)
                            let code = att?.status

                            if code == "success" {
                                print("Get attendance data successfully!")
                                self.reloadChart(aData: (att?.attendance) ?? [], uData: (att?.userData)!, dData: (att?.details)!)
                            } else {
                                print("Unsuccessfull in getting attendance data!")
                            }
                        }

                    case .failure:
                        print("Error Ocurred in student attendance data!")

                    }
                }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (userData?.profession == "Professor") {
            return 1
        }
        return 2

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var profession = ""
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! dataCell
            cell.selectionStyle = .none
            let name = self.userData?.name ?? ""
            if (self.userData?.gender == "Female") {
                cell.profile.image = #imageLiteral(resourceName:"female_image")
            } else {
                cell.profile.image = #imageLiteral(resourceName:"male_image")
            }
            profession = self.userData?.profession ?? ""
            cell.name.text = name
            cell.reg.text = self.userData?.regId ?? ""
            cell.dept.text = self.userData?.department ?? ""
            cell.email.text = self.userData?.email ?? ""
            cell.prof.text = profession


            if (profession == "Professor") {

                cell.profImg.image = #imageLiteral(resourceName:"professor")
                cell.advisorL.isHidden = true
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilesTableCell") as! ProfilesCell
            cell.selectionStyle = .none

            cell.attnd = self.attnd
            cell.delegate = self
            cell.collection.reloadData()
            //to recalculate height
            /*   let indexPath = IndexPath(item: 1, section: 0)
             tableView.reloadRows(at: [indexPath], with: .top) */

            return cell
        }/*else{
         var colors = ChartColorTemplates.material()
         colors.append(UIColor(rgb: 0x009688))
         colors.append(UIColor(rgb: 0xff9800))
         
         //[UIColor.brown,UIColor.blue,UIColor.black,UIColor.yellow,UIColor.red,UIColor.green]
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreCell
         Utils.setChart(pieChart: cell.pieChart, dataPoints: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"], values: [20.0, 20.0, 20.0, 20.0, 20.0, 20.0], colors: colors)
         cell.selectionStyle = .none
         
         return cell
         }*/
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if #available(iOS 11, *) {
            if indexPath.row == 1 {
                return 500
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

    func reloadChart(aData: [Attendance], uData: UserData, dData: Detail) {
        DispatchQueue.main.async {
            print("Refreshing data")
            self.attnd = aData
            self.userData = uData
            self.details = dData
            self.myTableView.reloadData()
        }
    }
}

extension ProfileViewController: AttendanceRowDelegate {
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


}



