// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import Kingfisher
import FirebaseMessaging
import Crashlytics

class InfoViewController: UIViewController {
    @IBOutlet weak var deleteGB: UIButton!
    @IBOutlet weak var barcodeIV: UIImageView!
    @IBOutlet weak var infoL: UILabel!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptAllB: UIButton!
    var group: Group?

    var final = [MessageItem]()

    var isAdmin: Bool? = nil
    var isDownload = true

    var fileURL: URL?

    var isNotification = false
    var studentId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Info controller added")

        title = group!.subjectName!

        if isNotification {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(InfoViewController.onClickDone))
            self.navigationItem.leftBarButtonItem = backButton
            self.checkIsLogin()
        }

        let u_id = Session.getInteger(forKey: Session.ID)
        infoL.text = "GroupCode: \(group!.groupCode!) by \(group!.adminName!)"

        let url = URL(string: group!.groupBarcode!)
        print("\(url!.absoluteString)")
        barcodeIV.kf.setImage(with: url)

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.getMembers()


        if (u_id == group?.groupAdmin!) {
            isAdmin = true

        } else {
            isAdmin = false
        }
        if (!isAdmin!) {
            self.deleteGB.isHidden = true
            self.acceptAllB.isHidden = true
        } else {
            self.deleteGB.isHidden = false
            self.acceptAllB.isHidden = true

        }
        buttonB.backgroundColor = .clear
        buttonB.layer.cornerRadius = 5
        buttonB.layer.borderWidth = 1
        buttonB.layer.borderColor = UIColor(rgb: 0x476AE8).cgColor

        deleteGB.backgroundColor = .clear
        deleteGB.layer.cornerRadius = 5
        deleteGB.layer.borderWidth = 1
        deleteGB.layer.borderColor = UIColor(rgb: 0x476AE8).cgColor

        acceptAllB.layer.cornerRadius = 5
        acceptAllB.layer.borderWidth = 1
        acceptAllB.layer.borderColor = UIColor.clear.cgColor


        tableView.register(MessageHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        checkIsDownload()
    }

    @IBAction func acceptAll(_ sender: Any) {
        setAction(id: "all", title: "Active", b: acceptAllB)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStudentData" {
            let controller = segue.destination as! ProfileViewController
            controller.studentId = self.studentId
        }
    }

    @objc func onClickDone() {
        print("on Click Done!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
        self.present(controller, animated: true, completion: nil)
    }

    func checkIsDownload() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = documentsURL.appendingPathComponent("WisOpt/BarCodes/\(String(describing: group!.groupCode!)).png")
        let checkValidation = FileManager.default

        if (checkValidation.fileExists(atPath: fileURL!.relativePath)) {
            print("FILE AVAILABLE");
            print(fileURL!.relativePath)
            buttonB.setTitle("Share QR Code", for: .normal)
            isDownload = false
            //Utils.showAlert(title: "File Available", message: "File Available", presenter: self)
            //barcodeIV.image = UIImage(contentsOfFile: fileURL.relativePath)
        } else {
            print("FILE NOT AVAILABLE");
            //Utils.showAlert(title: "File Not Available", message: "File Not Available", presenter: self)
            buttonB.setTitle("Download QR Code", for: .normal)
            print(fileURL!.relativePath)
            isDownload = true

        }
    }

    @IBAction func deleteGroup(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Group", message: "Do you want to delete the group \(group!.subjectName!)?", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
            action in
            if (action.style == .default) {
                self.deleteGroup()
            }
        }))

        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {
            action in
            if (action.style == .cancel) {
                print("Cancel")
            }
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)

    }

    func deleteGroup() {
        let u_id = Session.getInteger(forKey: Session.ID)
        //change this code
        guard let grp_id = group?.groupId else {
            print("group id error")
            return
        }

        let tc = Session.getString(forKey: Session.TOKEN_CODE)

        let url = URL(string: Utils.BASE_URL + "v2/delete")!
        let param: [String: String] = ["userId": "\(u_id)", "groupId": "\(grp_id)", "user_code": "\(tc)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Delete group successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)
                            print("delete grp", utf8Text)
                            print("status", serverResult!.status!)
                            if serverResult!.status! == "true" {
                                self.navigationController?.popToRootViewController(animated: true)

                                let email = Session.getString(forKey: Session.EMAIL)
                                
                                Answers.logCustomEvent(withName: "Group Deleted", customAttributes: ["Email": email])
                            } else {
                                Utils.showAlert(title: "Status", message: serverResult!.status!, presenter: self)
                            }

                        }

                    case .failure:
                        print("Error Ocurred! while adding token")
                    }
                }
    }


    //MARK: Other
    func getMembers() {
        let g_id = group!.groupId!

        let url = URL(string: Utils.BASE_URL + "v2/members")!
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let param: [String: String] = ["token": tc, "groupId": "\(g_id)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Get Members Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let memberList = Member(JSONString: utf8Text)
                            let mems = memberList!.members

                            //print(utf8Text)

                            //print("Count: \(mems?.count)")

                            var dict = [String: [Member]]()

                            for i in mems! {
                                //print("Status: \(i.status)")

                                var list = dict[i.status!] ?? []
                                list.append(i)
                                dict[i.status!] = list
                            }

                            self.final.removeAll()

                            if (self.isAdmin!) {
                                if dict["Pending"] != nil {
                                    self.final.append(MessageItem(header: "Pending"))
                                    for i in dict["Pending"]! {
                                        self.final.append(MessageItem(member: i))
                                    }
                                    self.acceptAllB.isHidden = false
                                }

                                if dict["Active"] != nil {
                                    self.final.append(MessageItem(header: "Active Member"))
                                    for i in dict["Active"]! {
                                        self.final.append(MessageItem(member: i))
                                    }
                                }

                                if dict["Block"] != nil {
                                    self.final.append(MessageItem(header: "Blocked"))
                                    for i in dict["Block"]! {
                                        self.final.append(MessageItem(member: i))
                                    }
                                }
                            } else {
                                if dict["Active"] != nil {
                                    self.final.append(MessageItem(header: "Active Member"))
                                    for i in dict["Active"]! {
                                        self.final.append(MessageItem(member: i))
                                    }
                                }
                            }

                            self.reloadTableView()

                        }
                    case .failure:
                        print("Error Ocurred!")

                        let alert = UIAlertController(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", preferredStyle: UIAlertControllerStyle.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                            action in
                            if (action.style == .default) {
                                self.getMembers()
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

    func setAction(id: Any, title: String, b: UIButton) {
        let gId = group!.groupId!

        b.isEnabled = false

        let url = URL(string: Utils.BASE_URL + "v2/members/request")!
        let param: [String: Any] = ["token": Session.getString(forKey: Session.TOKEN_CODE), "userId": "\(id)", "groupId": "\(gId)", "status": "\(title)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        b.isEnabled = true
                        print("Set Action Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            let email = Session.getString(forKey: Session.EMAIL)
                            
                            Answers.logCustomEvent(withName: "User Request \(title)", customAttributes: ["Email": email])

                            self.getMembers()

                        }
                    case .failure:
                        b.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            print("Refreshing data")
            self.tableView.reloadData()

        }
    }

    func showCAlert(title: String, message: String, action1: String, action2: String, presenter: UIViewController) {
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

    @IBAction func onClickButton(_ sender: UIButton) {
        shareOrDownload()
    }

    func checkIsLogin() {
        let IS_LOGIN = Session.getBool(forKey: Session.IS_LOGIN)
        print("IS_LOGIN: \(IS_LOGIN)")

        if (!IS_LOGIN) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            self.present(controller, animated: true, completion: nil)
        }
    }

    func shareOrDownload() {

        if isDownload {
            self.buttonB.isEnabled = false

            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("WisOpt/BarCodes/\(self.group!.groupCode!).png")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }


            let urlString = Utils.BASE_URL + "barcode/\(self.group!.groupCode!).png"
            Alamofire.download(urlString, to: destination).response { response in
                //print("Response: \(response)")
                self.buttonB.isEnabled = true
                if response.error == nil, let imagePath = response.destinationURL?.relativePath {
                    print(imagePath)
                    //let image = UIImage(contentsOfFile: imagePath)
                    //self.barcodeIV.image = image

                    let email = Session.getString(forKey: Session.EMAIL)
                    
                    Answers.logCustomEvent(withName: "QR Code Downloaded!", customAttributes: ["Email": email])

                    self.checkIsDownload()
                } else {
                    self.checkIsDownload()
                    print("Error Ocurred! \(String(describing: response.error))")
                }

            }
        } else {
            var objectsToShare = [AnyObject]()

            let shareImage = UIImage(contentsOfFile: fileURL!.relativePath)
            objectsToShare.append(shareImage!)
            if shareImage != nil {
                let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view

                present(activityViewController, animated: true, completion: nil)
            } else {
                print("There is nothing to share")
            }
        }
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return groups.count
        return final.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profession = Session.getString(forKey: Session.PROFESSION)

        print("Cell Type::: ", final[indexPath.row].type, profession)

        if final[indexPath.row].type == final[indexPath.row].MEMBER {
            if (profession == "Professor") {
                print("Selected User Profession: ", final[indexPath.row].member!.profession!)
                if final[indexPath.row].member!.profession! == "Student" {
                    self.studentId = final[indexPath.row].member!.id!
                    performSegue(withIdentifier: "segueToStudentData", sender: self)
                } else {
                    Utils.showAlert(title: "Warning", message: "Selected user is a Professor!", presenter: self)
                }
            } else {
                tableView.allowsSelection = false
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mem = final[indexPath.row]

        if mem.type == mem.HEADER {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? MessageHeaderCell else {
                fatalError("The dequeue cell is not an instance of HeaderTableViewCell.")
            }
            let h = mem.header

            cell.headerL.text = "\(h!)"
            return cell
        } else if mem.type == mem.MEMBER {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as? MemberTableViewCell else {
                fatalError("The dequeued cell is not an instance of RoomTableViewCell.")
            }
            let m = mem.member

            cell.nameL.text = m?.name ?? ""
            cell.registrationNumberL.text = m?.regId ?? ""
            cell.branchL.text = m?.department ?? ""
            cell.yearL.text = m?.year ?? ""
            cell.member = m


            if (self.isAdmin!) {

                if (m?.status! == "Active") {
                    cell.acceptB.setTitle("Block", for: .normal)
                    cell.acceptB.isHidden = false
                    cell.rejectB.isHidden = true

                    cell.acceptB.setTitleColor(.blue, for: .normal)

                    cell.onAcceptTapped = {
                        //print("Accept Tapped! \(cell.member?.name)")
                        self.setAction(id: (m!.id!), title: "Block", b: cell.acceptB)
                    }
                } else if (m?.status! == "Pending") {
                    cell.acceptB.setTitle("Accept", for: .normal)
                    cell.acceptB.isHidden = false
                    cell.rejectB.isHidden = false

                    cell.acceptB.setTitleColor(.green, for: .normal)

                    cell.onAcceptTapped = {
                        //print("Accept Tapped! \(cell.member?.name)")
                        self.setAction(id: (m!.id!), title: "Active", b: cell.acceptB)
                    }

                    cell.onRejectTapped = {
                        //print("Reject Tapped! \(cell.member?.name)")
                        self.setAction(id: (m!.id!), title: "Block", b: cell.rejectB)
                    }
                } else if (m?.status! == "Block") {
                    cell.acceptB.setTitle("Unblock", for: .normal)
                    cell.acceptB.isHidden = false
                    cell.rejectB.isHidden = true

                    cell.acceptB.setTitleColor(.blue, for: .normal)

                    cell.onAcceptTapped = {
                        self.setAction(id: (m!.id!), title: "Active", b: cell.acceptB)
                    }
                }

            } else {
                cell.acceptB.isHidden = true
                cell.rejectB.isHidden = true
            }

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? RoomTableViewCell else {
            fatalError("The dequeued cell is not an instance of RoomTableViewCell.")
        }


        return cell
    }
}

