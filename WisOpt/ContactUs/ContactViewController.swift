// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import Crashlytics

class ContactViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var typeB: UIButton!

    var IS_LOGIN = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }


    @IBAction func onClickType(_ sender: UIButton) {
        let alert = UIAlertController(title: "Buildings", message: "Choose a building", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.setValue(NSAttributedString(string: "Buildings", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17), NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x476AE8)]), forKey: "attributedTitle")

        for i in ["Select Feedback Type", "Bug", "Feedback", "Suggestion", "Crash", "Request"] {
            alert.addAction(UIAlertAction(title: i, style: UIAlertActionStyle.destructive, handler: setType))
        }

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func setType(alert: UIAlertAction) {
        typeB.setTitle(alert.title, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = false
    }

    func setupView() {

        feedbackButton.layer.cornerRadius = 5
        feedbackButton.layer.borderWidth = 1
        feedbackButton.layer.borderColor = UIColor.clear.cgColor
        feedbackButton.setTitleColor(UIColor.gray, for: .disabled)

        messageTV.layer.borderWidth = 1
        messageTV.layer.borderColor = UIColor.gray.cgColor
        messageTV.layer.cornerRadius = 5

        typeB.backgroundColor = .clear
        typeB.layer.cornerRadius = 5
        typeB.layer.borderWidth = 1
        typeB.layer.borderColor = UIColor(rgb: 0xcccccc).cgColor

        showOrHideEmailTF()

    }

    func showOrHideEmailTF() {
        IS_LOGIN = Session.getBool(forKey: Session.IS_LOGIN)

        if IS_LOGIN {
            emailIdTF.isHidden = true
        } else {
            emailIdTF.isHidden = false
        }
    }
}

extension ContactViewController {
    //MARK: Action
    @IBAction func onClickFeedback(_ sender: UIButton) {
        var email = emailIdTF.text
        let subject = subjectTF.text

        let description = messageTV.text

        let type = typeB.currentTitle!

        if (IS_LOGIN) {
            email = Session.getString(forKey: Session.EMAIL)
        } else {
            email = emailIdTF.text
        }

        if (type == "Select Feedback Type") {
            Utils.showAlert(title: "Error!", message: "Please Select a Feedback type.", presenter: self)
            return
        }


        if (email?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Email Cannot Be Empty.", presenter: self)
            return
        }

        if !(email?.contains("@"))! {
            Utils.showAlert(title: "Error!", message: "Invalid Email.", presenter: self)
            return
        }

        if (subject?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Subject Cannot Be Empty.", presenter: self)
            return
        }

        if (description?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Description Cannot Be Empty.", presenter: self)
            return
        }

        self.sendFeedback(email: email!, subject: subject!, description: description!, type: type)
    }

    func sendFeedback(email: String, subject: String, description: String, type: String) {
        feedbackButton.isEnabled = false

        let url = URL(string: Utils.BASE_URL + "API")!
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let param: [String: String] = ["token": tc, "u_id": "-1", "subject": "\(subject)", "type": type, "message": "\(description)\nBy\n\(email)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.feedbackButton.isEnabled = true
                        print("Register Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                Utils.showAlertWithAction(title: "Feedback Sent!", message: "Thank You for leaving us a feedback. We are continuously working to improve our service.\nTeam WisOpt", presenter: self)
                                Answers.logCustomEvent(withName: "Feedback Added", customAttributes: ["Email": email])
                            } else {
                                Utils.showAlert(title: "Error", message: serverResult!.status!, presenter: self)
                            }

                        }
                    case .failure:
                        self.feedbackButton.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }
}
