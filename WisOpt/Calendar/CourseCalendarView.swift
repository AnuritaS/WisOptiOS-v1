//
//  CoursesCourseendarView.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 09/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit
import Alamofire

extension CalendarViewController {

    func getCourses() {
        let u_id = Session.getInteger(forKey: Session.ID)
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let param: [String: String] = ["userId": "\(u_id)", "token": "\(tc)"]

        Alamofire.request(Utils.BASE_URL + "v2/calendar/course", method: .post, parameters: param).responseJSON { response in

            switch response.result {
            case .success:

                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    //print(utf8Text)
                    let sCourse = Student_course(JSONString: utf8Text)
                    if (sCourse!.status! == "true") {
                        print("Got Course Data successfully")

                        self.sCourse = (sCourse!.course!)
                        self.sSlots = (sCourse!.slots!)


                        //                        self.reloadTableView()
                        self.calendar.reloadData()
                    }
                }
            case .failure:
                print("Error Ocurred in getting sCourseendar data!")

                let alert = UIAlertController(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", preferredStyle: UIAlertControllerStyle.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                    action in
                    if (action.style == .default) {
                        self.getCourses()
                    }
                }))

                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: {
                    action in
                    if (action.style == .cancel) {
                        print("Cancel")
                    }
                }))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToEvent" {
            let controller = segue.destination as! eventPopUpViewController
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.message.count
        } else {
            return self.courses.count
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell") as? EventTableCell
            if !self.message[indexPath.row].contains("DayOrder") {
                cell?.info.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
            }
            cell?.info.text = self.message[indexPath.row]
            //   cell.eventImg.image = self.message[indexPath.row].
            cell?.info.dataDetectorTypes = .all
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableCell") as? CourseTableCell
            cell?.selectionStyle = .none
            if self.courses[indexPath.row].slot.containsString(find: "P") {
                cell?.slotBG.backgroundColor = UIColor(rgb: 0xAFCFDB)
            } else {
                cell?.slotBG.backgroundColor = UIColor(rgb: 0xF7ABB4)
            }
            cell?.subjectN.text = self.courses[indexPath.row].subject
            cell?.courseC.text = self.courses[indexPath.row].subjectCode
            cell?.facultyNI.text = self.courses[indexPath.row].faculty
            cell?.room_lab.text = self.courses[indexPath.row].room
            cell?.time_frm.text = self.courses[indexPath.row].timeFrom
            cell?.time_to.text = self.courses[indexPath.row].timeTo
            cell?.slot.text = self.courses[indexPath.row].slot
            cell?.batch.text = "Batch \(self.courses[indexPath.row].batch)"

            return cell!
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /*   if indexPath.section == 0 {
           self.performSegue(withIdentifier:  "segueToEvent", sender: self)
           }*/
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(rgb: 0xE7E7E7)

        return header
    }

}
