// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import BEMCheckBox
import Crashlytics

class RoomsViewController: UIViewController, BEMCheckBoxDelegate {

    //MARK: Properties
    @IBOutlet weak var roomTF: UITextField!
    @IBOutlet weak var vacantCB: BEMCheckBox!
    @IBOutlet weak var selectBuildingB: UIButton!
    @IBOutlet weak var currentTimeCB: BEMCheckBox!
    @IBOutlet weak var customTimeCB: BEMCheckBox!
    @IBOutlet weak var timeSlotB: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchB: UIButton!

    var timeSlots: [String] = [String]()
    var slots: [String] = [String]()

    var selectedDate = ""

    var roomList: [Room] = [Room]()
    var details: RoomDetail? = nil

    var group: BEMCheckBoxGroup?

    var currentTime = true
    var vacantRooms = false

    override func viewDidLoad() {
        super.viewDidLoad()

        print("rooms view controller added!")

        vacantCB.boxType = .square
        currentTimeCB.onAnimationType = .fill
        customTimeCB.onAnimationType = .fill

        group = BEMCheckBoxGroup(checkBoxes: [self.currentTimeCB, self.customTimeCB])
        group?.selectedCheckBox = self.currentTimeCB// Optionally set which checkbox is pre-selected
        group?.mustHaveSelection = true

        vacantCB.delegate = self
        currentTimeCB.delegate = self
        customTimeCB.delegate = self

        timeSlotB.isEnabled = false
        datePicker.isEnabled = false

        timeSlots = ["Select time slot", "8:00–8:50", "8:50–9:40", "9:45–10:35", "10:40–11:30", "11:35–12:25", "12:30–1:20", "1:25–2:15", "2:20–3:10", "3:15–4:05", "4:05–4:55"]
        slots = ["0:00:00", "8:10:00", "9:00:00", "9:55:00", "10:50:00", "11:45:00", "12:40:00", "13:35:00", "14:30:00", "15:25:00", "16:15:00"]

        selectBuildingB.backgroundColor = .clear
        selectBuildingB.layer.cornerRadius = 5
        selectBuildingB.layer.borderWidth = 1
        selectBuildingB.layer.borderColor = UIColor(rgb: 0xcccccc).cgColor

        timeSlotB.backgroundColor = .clear
        timeSlotB.layer.cornerRadius = 5
        timeSlotB.layer.borderWidth = 1
        timeSlotB.layer.borderColor = UIColor(rgb: 0xcccccc).cgColor

        searchB.backgroundColor = .clear
        searchB.layer.cornerRadius = 5
        searchB.layer.borderWidth = 1
        searchB.layer.borderColor = UIColor(rgb: 0x476ae8).cgColor

    }

    //MARK:Actions
    @IBAction func onClickBuilding(_ sender: UIButton) {
        let alert = UIAlertController(title: "Buildings", message: "Choose a building", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.setValue(NSAttributedString(string: "Buildings", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x476AE8)]), forKey: "attributedTitle")
        for i in ["Select building", "UNIVERSITY BUILDING", "TECH PARK", "BIO ENGINEERING", "ELEC.SCIENCE", "CRC BUILDING", "HI-TECH", "MECHANICAL A", "OLD LIBRARY", "MAIN"] {
            alert.addAction(UIAlertAction(title: i, style: UIAlertActionStyle.destructive, handler: building))
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func onClickTimeSlot(_ sender: UIButton) {
        let alert = UIAlertController(title: "Timings", message: "Choose a building", preferredStyle: UIAlertControllerStyle.actionSheet)
        for i in timeSlots {
            alert.addAction(UIAlertAction(title: i, style: UIAlertActionStyle.destructive, handler: timeSlot))
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func building(alert: UIAlertAction) {
        selectBuildingB.setTitle(alert.title, for: .normal)
    }

    func timeSlot(alert: UIAlertAction) {
        timeSlotB.setTitle(alert.title, for: .normal)
    }

    func didTap(_ checkBox: BEMCheckBox) {
        print("TApped")
        if checkBox == self.currentTimeCB {
            timeSlotB.isEnabled = false
            datePicker.isEnabled = false
            currentTime = true
            return
        } else if checkBox == self.customTimeCB {
            timeSlotB.isEnabled = true
            datePicker.isEnabled = true
            currentTime = false
            return
        }

        if checkBox == self.vacantCB {
            print(vacantCB.on)
            if (vacantCB.on) {
                roomTF.isEnabled = false
                vacantRooms = true
                searchB.setTitle("Search Vacant Rooms", for: .normal)
            } else {
                roomTF.isEnabled = true
                vacantRooms = false
                searchB.setTitle("Get Room Detail", for: .normal)
            }
        }
    }


    @IBAction func onClickSearch(_ sender: UIButton) {
        let room = roomTF.text
        let building = selectBuildingB.currentTitle!
        let timeSlot = timeSlotB.currentTitle!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yy"
        let selectedDate = dateFormatter.string(from: datePicker.date)


        let u_id = Session.getInteger(forKey: Session.ID)

        print("\(String(describing: room))")
        print("\(building)")
        print("\(timeSlot)")

        if (building == "Select building") {
            Utils.showAlert(title: "Error!", message: "Please Select a building.", presenter: self)
            return
        }

        if (!vacantRooms) {
            if (room?.isEmpty)! {
                Utils.showAlert(title: "Error!", message: "Room Cannot Be Empty.", presenter: self)
                return
            }

            if (currentTime) {
                let date = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MMM-yy"
                let d = dateFormatter.string(from: date as Date)
                print(d)

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:00"
                let t = timeFormatter.string(from: date as Date)
                print(t)

                searchRoom(room: room!, current_day: d, current_time: t, block: building, u_id: u_id)

            } else {
                if (timeSlot == "Select time slot") {
                    Utils.showAlert(title: "Error!", message: "Please Select Time Slot.", presenter: self)
                    return
                }

                let slot = slots[timeSlots.index(of: timeSlot)!]

                print(selectedDate)
                print(slot)

                searchRoom(room: room!, current_day: selectedDate, current_time: slot, block: building, u_id: u_id)
            }
        } else {
            if (currentTime) {
                let date = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MMM-yy"
                let d = dateFormatter.string(from: date as Date)
                print(d)

                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:00"
                let t = timeFormatter.string(from: date as Date)
                print(t)

                vacantRoom(current_day: d, current_time: t, block: building)
            } else {
                if (timeSlot == "Select time slot") {
                    Utils.showAlert(title: "Error!", message: "Please Select Time Slot.", presenter: self)
                    return
                }

                let slot = slots[timeSlots.index(of: timeSlot)!]

                print(selectedDate)
                print(slot)

                vacantRoom(current_day: selectedDate, current_time: slot, block: building)
            }
        }
    }

    //MARK: Other
    func searchRoom(room: String, current_day: String, current_time: String, block: String, u_id: Int) {
        searchB.isEnabled = false

        let url = URL(string: Utils.BASE_URL + "API")!
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let param: [String: String] = ["token": tc, "room": "\(room)", "current_day": "\(current_day)", "current_time": "\(current_time)", "block": "\(block)", "u_id": "\(u_id)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.searchB.isEnabled = true
                        print("Get Room Details Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("utf", utf8Text)

                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                let details = serverResult!.roomDetails

                                self.details = details!
                                print("\(String(describing: details?.facultyName))")

                                let email = Session.getString(forKey: Session.EMAIL)
                                
                                Answers.logCustomEvent(withName: "Room Details Searched", customAttributes: ["Email": email])

                                self.performSegue(withIdentifier: "DetailsVC", sender: self)

                            } else {
                                Utils.showAlert(title: "Status", message: serverResult!.status!, presenter: self)
                            }

                        }
                    case .failure:
                        self.searchB.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }

    func vacantRoom(current_day: String, current_time: String, block: String) {
        searchB.isEnabled = false

        let url = URL(string: Utils.BASE_URL + "API")!
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let param: [String: String] = ["token": tc, "current_day": "\(current_day)", "current_time": "\(current_time)", "block": "\(block)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.searchB.isEnabled = true
                        print("Get Vacant Room Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            //print(utf8Text)

                            let roomList = RoomList(JSONString: utf8Text)
                            let rooms = roomList!.rooms

                            print(roomList!.status!)

                            if roomList!.status! == "true" {
                                print("\(String(describing: rooms?.count))")
                                print("\(String(describing: roomList!.status))")

                                if (rooms?.count == 0) {
                                    Utils.showAlert(title: "No Vacant Rooms!", message: "No Vacant Rooms Available at this time.", presenter: self)
                                    return
                                }

                                let email = Session.getString(forKey: Session.EMAIL)
                                Answers.logCustomEvent(withName: "Vacant Room Searched", customAttributes: ["Email": email])

                                self.roomList.removeAll()
                                self.roomList.append(contentsOf: rooms!)

                                self.performSegue(withIdentifier: "vacantVC", sender: self)

                            } else {
                                Utils.showAlert(title: "Status", message: roomList!.status!, presenter: self)
                            }

                        }
                    case .failure:
                        self.searchB.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "vacantVC") {
            //get a reference to the destination view controller
            let destinationVC = segue.destination as! VacantTableViewController

            //set properties on the destination view controller
            destinationVC.rooms = roomList
            //etc...
        } else if (segue.identifier == "DetailsVC") {
            //get a reference to the destination view controller
            let destinationVC = segue.destination as! DetailsViewController

            //set properties on the destination view controller
            destinationVC.details = self.details
            //etc...
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
