// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import BarcodeScanner
import Crashlytics

class ManageViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var groupNameTF: UITextField!
    @IBOutlet weak var uniqueCodeTF: UITextField!
    @IBOutlet weak var joinCodeTF: UITextField!
    @IBOutlet weak var createGroupB: UIButton!
    @IBOutlet weak var joinGroupB: UIButton!
    @IBOutlet weak var OrLabel: UILabel!
    @IBOutlet weak var scanB: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Manage View Controller Added!")
        groupNameTF.delegate = self
        uniqueCodeTF.delegate = self

        let prof = Constant().getProfession()
        if prof == "Student" {
            print("No create group option for student")
            self.groupNameTF.isHidden = true
            self.uniqueCodeTF.isHidden = true
            self.createGroupB.isHidden = true
            self.OrLabel.isHidden = true
        } else if prof == "Professor" {

            self.groupNameTF.isHidden = false
            self.uniqueCodeTF.isHidden = false
            self.createGroupB.isHidden = false
            self.OrLabel.isHidden = false

        }


        createGroupB.layer.cornerRadius = 5
        createGroupB.layer.borderWidth = 1
        createGroupB.layer.borderColor = UIColor.clear.cgColor
        createGroupB.setTitleColor(UIColor.gray, for: .disabled)

        joinGroupB.layer.cornerRadius = 5
        joinGroupB.layer.borderWidth = 1
        joinGroupB.layer.borderColor = UIColor.clear.cgColor

        scanB.layer.cornerRadius = 5
        scanB.layer.borderWidth = 1
        scanB.layer.borderColor = UIColor.clear.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }

    //MARK: Action
    @IBAction func onClickCreateGroup(_ sender: UIButton) {
        let grpName = groupNameTF.text
        let grpCode = uniqueCodeTF.text

        if (grpName?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Group Name Cannot Be Empty.", presenter: self)
            return
        }

        if (grpCode?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Group Code Cannot Be Empty.", presenter: self)
            return
        }

        self.createGroup(groupName: grpName!, groupCode: grpCode!)
    }

    @IBAction func onClickJoinGroup(_ sender: UIButton) {
        let grpCode = joinCodeTF.text

        if (grpCode?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Group Code Cannot Be Empty.", presenter: self)
            return
        }

        self.joinGroup(groupCode: grpCode!, isBarcode: false)

    }

    func createGroup(groupName: String, groupCode: String) {
        let u_id = Session.getInteger(forKey: Session.ID)
        createGroupB.isEnabled = false

        let url = URL(string: Utils.BASE_URL + "v2/create")!
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let param: [String: String] = ["token": tc, "subName": "\(groupName)", "subCode": "\(groupCode)", "userId": "\(u_id)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.createGroupB.isEnabled = true
                        print("Create Group Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)
                            print(utf8Text)
                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                Utils.showAlertWithAction(title: "Group Created!", message: "Group Succesfully Created.\nGroupName: \(groupName)\nSubjectName: \(groupCode)", presenter: self)
                                let email = Session.getString(forKey: Session.EMAIL)
                                
                                Answers.logCustomEvent(withName: "New Group Created", customAttributes: ["Name": email, "GroupName": groupName, "GroupCode": groupCode])
                            } else {
                                Utils.showAlert(title: "Error", message: serverResult!.status!, presenter: self)
                            }

                        }
                    case .failure:
                        self.createGroupB.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }

    func joinGroup(groupCode: String, isBarcode: Bool) {
        let u_id = Session.getInteger(forKey: Session.ID)
        joinGroupB.isEnabled = false

        let url = URL(string: Utils.BASE_URL + "v2/join")!
        let param: [String: String] = ["token": Session.getString(forKey: Session.TOKEN_CODE), "code": "\(groupCode)", "userId": "\(u_id)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.joinGroupB.isEnabled = true
                        print("Join Group Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                Utils.showAlertWithAction(title: "Group Joined!", message: "You have successfully joined the group.", presenter: self)
                                let email = Session.getString(forKey: Session.EMAIL)
                                
                                if isBarcode {
                                    Answers.logCustomEvent(withName: "New Group Joined", customAttributes: ["Name": email, "GroupCode": groupCode])
                                } else {
                                    Answers.logCustomEvent(withName: "New Group Joined Using Barcode", customAttributes: ["Name": email, "GroupCode": groupCode])
                                }

                            } else {
                                Utils.showAlert(title: "Status", message: serverResult!.status!, presenter: self)
                            }

                        }
                    case .failure:
                        self.joinGroupB.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }

}

extension ManageViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        self.joinCodeTF.text = code
        self.joinGroup(groupCode: code, isBarcode: true)
        controller.dismiss(animated: true, completion: nil)
    }

    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }

    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }


    @IBAction func scanCode(_ sender: Any) {
        let controller = BarcodeScannerViewController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self

        present(controller, animated: true, completion: nil)
    }

}

extension ManageViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return textField.text!.count + string.count - range.length <= 30
    }


}

