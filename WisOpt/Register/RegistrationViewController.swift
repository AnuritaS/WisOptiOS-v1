// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import BEMCheckBox
import Crashlytics

class RegistrationViewController: UIViewController, BEMCheckBoxDelegate {

    @IBOutlet weak var Register: UIButton!
    @IBOutlet weak var studentCheck: BEMCheckBox!
    @IBOutlet weak var professorCheck: BEMCheckBox!
    @IBOutlet weak var maleCheck: BEMCheckBox!
    @IBOutlet weak var femaleCheck: BEMCheckBox!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var IdLine: UIView!
    @IBOutlet weak var fnameLine: UIView!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lnameLine: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    var prof = "Student"
    var gen = "Male"

    var group: BEMCheckBoxGroup?
    var group1: BEMCheckBoxGroup?

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView()
        fname.delegate = self
        lname.delegate = self
        id.delegate = self
        email.delegate = self
        self.studentCheck.boxType = .square
        self.professorCheck.boxType = .square
        self.maleCheck.boxType = .square
        self.femaleCheck.boxType = .square

        group = BEMCheckBoxGroup(checkBoxes: [self.studentCheck, self.professorCheck])
        //group?.selectedCheckBox = self.studentCheck// Optionally set which checkbox is pre-selected
        //group?.mustHaveSelection = true

        group1 = BEMCheckBoxGroup(checkBoxes: [self.maleCheck, self.femaleCheck])
        //group1?.selectedCheckBox = self.maleCheck// Optionally set which checkbox is pre-selected
        //group1?.mustHaveSelection = true

        studentCheck.delegate = self
        professorCheck.delegate = self
        maleCheck.delegate = self
        femaleCheck.delegate = self


        studentCheck.accessibilityLabel = "Student"
        professorCheck.accessibilityLabel = "Professor"
        maleCheck.accessibilityLabel = "Male"
        femaleCheck.accessibilityLabel = "Female"

        title = "Register"


    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = false
    }

    //MARK: Actions
    @IBAction func onClickRegister(_ sender: UIButton) {
        let university = "SRM University, KTR Campus"
        let profession = self.group?.selectedCheckBox?.accessibilityLabel
        print("Profession: \(String(describing: profession))")
        let fname = self.fname.text
        let lname = self.lname.text
        var gender = self.group1?.selectedCheckBox?.accessibilityLabel
        print("Gender: \(String(describing: gender))")
        let regId = self.id.text
        let email = self.email.text

        if (fname?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "First Name Cannot Be Empty.", presenter: self)
            return
        }
        if (lname?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Last Name Cannot Be Empty.", presenter: self)
            return
        }

        if (profession == nil) {
            Utils.showAlert(title: "Error!", message: "Please select a profession.", presenter: self)
            return
        }

        if (gender == nil) {
            gender = "NA"
        }

        if (regId?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Register Id Cannot Be Empty.", presenter: self)
            return
        }

        if profession == "Student" {
            if regId?.count != 15 {
                Utils.showAlert(title: "Error!", message: "Not a Valid Format for Student Register Id.", presenter: self)
                return
            } else {

                let index = regId?.index((regId?.startIndex)!, offsetBy: 2)
                let numS = Int(String(regId![index!...]))
                print("\(String(describing: numS))")
                if (numS == nil) {
                    Utils.showAlert(title: "Error!", message: "Not a Valid Register Id For Student.", presenter: self)
                    return
                }

            }
        }

        if (email?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Email Cannot Be Empty.", presenter: self)
            return
        } else {
            if !(email?.contains("@"))! {
                Utils.showAlert(title: "Error!", message: "Invalid Email.", presenter: self)
                return
            }

            if profession == "Student" {
                let se = "@srmuniv.edu.in"

                if !(email?.hasSuffix(se))! {
                    Utils.showAlert(title: "Error!", message: "Please use SRM email Id.", presenter: self)
                    return
                }
            }
        }

        self.registerUser(university: university, profession: profession!, name: fname! + " " + lname!, gender: gender!, regId: regId!, email: email!)
    }


    //Other Functions
    func registerUser(university: String, profession: String, name: String, gender: String, regId: String, email: String) {
        self.Register.isEnabled = false

        print("\(university)")
        print("\(profession)")
        print("\(name)")
        print("\(gender)")
        print("\(regId)")
        print("\(email)")

        let url = URL(string: Utils.BASE_URL + "v2/register")!
        let param: [String: String] = ["university": "\(university)", "profession": "\(profession)", "email": "\(email)", "name": "\(name)", "gender": "\(gender)", "reg_id": "\(regId)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.Register.isEnabled = true
                        print("Register Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                Utils.showAlertWithAction(title: "Registraion Successful!", message: "We have sent a verification mail to \(email).\nPlease verify your email.", presenter: self)
                                Answers.logSignUp(withMethod: "SignUp",
                                        success: true,
                                        customAttributes: ["Name": name, "Email": email, "Profession": profession])
                            } else {
                                Utils.showAlert(title: "Error", message: serverResult!.status!, presenter: self)
                                Answers.logSignUp(withMethod: "SignUp",
                                        success: false,
                                        customAttributes: ["Name": name, "Email": email, "Profession": profession])
                            }

                        }
                    case .failure:
                        self.Register.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }

    }
}

extension RegistrationViewController: UITextFieldDelegate {

    func buttonView() {

        Register.layer.cornerRadius = 5
        Register.layer.borderWidth = 1
        Register.layer.borderColor = UIColor.clear.cgColor
        Register.setTitleColor(UIColor.gray, for: .disabled)

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fname {
            fnameLine.backgroundColor = UIColor(rgb: 0x476ae8)
        }
        if textField == lname {
            lnameLine.backgroundColor = UIColor(rgb: 0x476ae8)
        }
        if textField == id {
            IdLine.backgroundColor = UIColor(rgb: 0x476ae8)
        }
        if textField == email {
            emailLine.backgroundColor = UIColor(rgb: 0x476ae8)
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fname {
            fnameLine.backgroundColor = UIColor(rgb: 0x000000)
        }
        if textField == id {
            IdLine.backgroundColor = UIColor(rgb: 0x000000)
        }
        if textField == email {
            emailLine.backgroundColor = UIColor(rgb: 0x000000)
        }
    }

}
