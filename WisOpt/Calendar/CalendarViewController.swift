// WisOpt copyright Monkwish 2017

import UIKit
import Foundation
import FSCalendar
import Alamofire
import NVActivityIndicatorView


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var feedbackB: UIButton!

    var imageVi = [#imageLiteral(resourceName:"calendar_event"), #imageLiteral(resourceName:"image_addFile")]
    fileprivate let gregorian = NSCalendar(identifier: .gregorian)

    var examList = [Event]()
    var colorList = [Color]()
    var feedbackList = [Feedback]()
    var academicList = [DayOrder]()
    var eventList = [EventFeed]()

    var message = [String]()
    var courses = [CourseRow]()

    var datesWithExam = [String]()
    var datesWithAcademic = [String]()
    var datesWithEvent = [String]()

    var sCourse = [Course]()
    var sSlots = [Slot]()

    var selectedEventId = ""
    var feedbackCode = ""
    var previousOffset = CGFloat()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    lazy var refreshControl = UIRefreshControl()

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.firstWeekday = 2
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.isHidden = true
        self.feedbackB.isHidden = true

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        getEvents()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter2.string(from: date)
        let dateString2 = self.dateFormatter.string(from: date)

        var count = 0

        if self.datesWithExam.contains(dateString) {
            count += 1
        }
        if self.datesWithAcademic.contains(dateString2) {
            let ind = self.datesWithAcademic.index(of: dateString2)
            let dayOrder = self.academicList[ind!]
            if (dayOrder.event! != "") {
                count += 1
            }
            if (dayOrder.dayOrder != "") {
                count += 1
            }
        }
        if self.datesWithEvent.contains(dateString2) {
            count += 1

        }

        return count
    }


    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        var color = [UIColor.blue]
        let key = self.dateFormatter.string(from: date)
        let key2 = self.dateFormatter2.string(from: date)

        if self.datesWithAcademic.contains(key) {
            let ind = self.datesWithAcademic.index(of: key)
            let dayOrder = self.academicList[ind!]
            if (dayOrder.event != "") || self.datesWithExam.contains(key2) {
                color.insert(UIColor.red, at: 0)
            }
            if (dayOrder.dayOrder != "") {
                color.insert(UIColor.gray, at: 0)
            }
        }

        return color
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.tableView.isHidden = true
        self.feedbackB.isHidden = true

        self.message.removeAll()
        self.courses.removeAll()

        let dateString = self.dateFormatter2.string(from: date)
        let dateString2 = self.dateFormatter.string(from: date)

        if self.datesWithExam.contains(dateString) {

            let ind = self.datesWithExam.index(of: dateString)

            let event = self.examList[ind!]

            self.selectedEventId = String(describing: event.eId!)


            self.message.append("Subject Name: \(event.eSubjectName!)\nSubject Code: \(event.eSubjectCode!)\nSemester: \(event.eSemester!)\nDepartment: \(event.eDepartment!)")
            self.message.append("\nDate: \(event.eDate!)\nSession: \(event.eSession!)\nStart: \(event.eStart!)\nEnd: \(event.eEnd!)\tBlock: \(event.eBlock!)\tRoom: \(event.eRoom!)")

            self.tableView.isHidden = false

            self.feedbackB.isHidden = false

            let feedback = feedbackList[ind!]
            //let color = colorList[ind!]

            //print(dateString, feedback.eFeedback)

            if (feedback.eFeedback == "1") {
                feedbackB.isEnabled = true
                feedbackB.setTitle("Give feedback", for: .normal)
            } else if (feedback.eFeedback == "0") {
                feedbackB.isEnabled = false
                feedbackB.setTitle("Exam not Conducted", for: .normal)
            } else {
                feedbackB.isEnabled = false
                feedbackB.setTitle(feedback.eFeedback, for: .normal)
            }


        }
        if self.datesWithAcademic.contains(dateString2) {

            let ind = self.datesWithAcademic.index(of: dateString2)
            let dayOrder = self.academicList[ind!]
            if dayOrder.dayOrder! == "" {
                self.message.append("Event: \(dayOrder.event!)")
            } else if dayOrder.event! == "" {
                self.message.append("DayOrder: \(dayOrder.dayOrder!)")
            } else if dayOrder.event! != "" && dayOrder.dayOrder! != "" {
                self.message.append("DayOrder: \(dayOrder.dayOrder!)\nEvent: \(dayOrder.event!)")
            }

            self.tableView.isHidden = false
            self.feedbackB.isHidden = true

            if (dayOrder.dayOrder! != "") {
                for slot in sSlots {
                    for course in sCourse {
                        if (slot.tDayOrder! == dayOrder.dayOrder! && course.sSlot! == "LAB" && course.sBatch! == slot.batch!) {
                            let courseSlots = course.sLabSlot!.components(separatedBy: " ")
                            if courseSlots.contains(slot.tSlot!) {
                                let courseRow = CourseRow(s: "\(course.sCourseTitle!)", c: "\(course.sCourseCode!)", f: "\(course.sFacultyName!)-\(course.sFacultyId!)", r: course.sClassroom!, tf: slot.classFrom!, tt: slot.classTo!, sl: slot.tSlot!, b: slot.batch!)
                                self.courses.append(courseRow)

                            }

                        } else if (slot.tDayOrder! == dayOrder.dayOrder! && slot.tSlot == course.sSlot && course.sBatch == slot.batch) {
                            let courseRow = CourseRow(s: "\(course.sCourseTitle!)", c: "\(course.sCourseCode!)", f: "\(course.sFacultyName!)-\(course.sFacultyId!)", r: course.sClassroom!, tf: slot.classFrom!, tt: slot.classTo!, sl: slot.tSlot!, b: slot.batch!)
                            self.courses.append(courseRow)
                        }

                    }
                }
            }

        }

        if self.datesWithEvent.contains(dateString2) {
            var index = 0;
            for i in datesWithEvent {
                if (i == dateString2) {
                    let event = self.eventList[index]

                    let msg = "\(event.eventTitle!)\nVenue: \(event.eventVenue!)\n\(event.eventLink!)\nTime: \(event.eventTime!)\nFee: \(event.eventFee!)\t\tOD: \(event.eventOD!)"
                    self.message.append(msg)
                }
                index = index + 1
            }

            self.tableView.isHidden = false
            self.feedbackB.isHidden = true
        }

        self.reloadTableView()
    }

    @IBAction func giveFeedback(_ sender: Any) {
        let alert = UIAlertController(title: "Feedback", message: "Choose a rating", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.setValue(NSAttributedString(string: "Feedback", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x476AE8)]), forKey: "attributedTitle")
        for i in ["Very Good", "Good", "Average", "Bad", "Very Bad"] {
            alert.addAction(UIAlertAction(title: i, style: UIAlertActionStyle.destructive, handler: feedback))
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func feedback(alert: UIAlertAction) {
        feedbackB.setTitle(alert.title, for: .normal)
        feedbackB.isEnabled = false

        self.feedbackCode = alert.title!
        sendFeedback()
    }

}

extension CalendarViewController {
    func reloadTableView() {
        DispatchQueue.main.async {
            print("Refreshing data")
            self.tableView.reloadData()
            //self.studentTableView.reloadData()
            // self.refreshControl.endRefreshing()
        }

    }

    func checkFeedback() {
        for feedback in feedbackList {
            for exam in examList {
                if (feedback.eId == exam.eId) {
                    //print(feedback.eFeedback)
                    feedbackB.setTitle(feedback.eFeedback, for: .normal)
                    feedbackB.isEnabled = false
                }
            }
        }
    }

    func sendFeedback() {
        let eId = self.selectedEventId
        let code = self.feedbackCode

        let u_id = Session.getInteger(forKey: Session.ID)
        let tc = Session.getString(forKey: Session.TOKEN_CODE)

        let url = URL(string: Utils.BASE_URL + "API")!
        let param: [String: String] = ["userId": "\(u_id)", "token": "\(tc)", "e_id": "\(eId)", "feedback_code": "\(code)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Send Feedback Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)
                            let status = serverResult?.status

                            if status != "true" {
                                Utils.showAlert(title: "Status!", message: status!, presenter: self)
                            }
                            self.getEvents()
                        }
                    case .failure:
                        print("Error Ocurred!")
                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                        self.getEvents()
                    }
                }
    }

    @objc func getEvents() {
        let u_id = Session.getInteger(forKey: Session.ID)
        let tc = Session.getString(forKey: Session.TOKEN_CODE)

        let url = URL(string: Utils.BASE_URL + "API")!
        let param: [String: String] = ["userId": "\(u_id)", "token": "\(tc)"]
        //NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    switch response.result {
                    case .success:
                        print("Get Events Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let getEventList = GetEventList(JSONString: utf8Text)
                            let examList = getEventList?.examList
                            let colorList = getEventList?.colorList
                            let feedbackList = getEventList?.feedbackList
                            let academicList = getEventList?.academicList
                            let eventList = getEventList?.events

                            //exam list
                            if examList != nil && colorList != nil && feedbackList != nil {
                                self.examList.removeAll()
                                self.examList.append(contentsOf: examList!)

                                self.colorList.removeAll()
                                self.colorList.append(contentsOf: colorList!)

                                self.feedbackList.removeAll()
                                self.feedbackList.append(contentsOf: feedbackList!)

                                self.datesWithExam.removeAll()
                                for i in self.examList {
                                    self.datesWithExam.append(i.eDate!)
                                }
                            }

                            //academic list
                            if (academicList != nil) {
                                self.academicList.removeAll()
                                self.academicList.append(contentsOf: academicList!)
                            }

                            self.datesWithAcademic.removeAll()
                            for i in self.academicList {
                                self.datesWithAcademic.append(i.oDate!)
                            }

                            //event list
                            if (eventList != nil) {
                                self.eventList.removeAll()
                                self.eventList.append(contentsOf: eventList!)
                            }

                            self.datesWithEvent.removeAll()
                            for i in self.eventList {
                                self.datesWithEvent.append(i.eventDate!)
                            }

                            self.calendar.reloadData()

                            self.getCourses()

                        }
                    case .failure:
                        print("Error Ocurred!")

                        let alert = UIAlertController(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", preferredStyle: UIAlertControllerStyle.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                            action in
                            if (action.style == .default) {
                                self.getEvents()
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

}

extension CalendarViewController: UIGestureRecognizerDelegate {


    func setupView() {
        self.calendar.layer.shadowColor = UIColor.gray.cgColor
        self.calendar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.calendar.layer.shadowRadius = 3
        self.calendar.layer.shadowOpacity = 0.8

        self.tableView.layer.shadowColor = UIColor.black.cgColor
        self.tableView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.tableView.layer.shadowRadius = 5
        self.tableView.layer.shadowOpacity = 0.5


        self.feedbackB.backgroundColor = .clear
        self.feedbackB.layer.cornerRadius = 5
        self.feedbackB.layer.borderWidth = 1
        self.feedbackB.layer.borderColor = UIColor(rgb: 0x476ae8).cgColor
    }

}

extension String {
    func containsString(find: String) -> Bool {
        return self.range(of: find) != nil
    }

    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
