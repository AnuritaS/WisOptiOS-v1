// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import Crashlytics

class ForgotViewController: ViewController {
    //MARK: Properties
    @IBOutlet weak var registeredEmailTF: UITextField!
    @IBOutlet weak var requestMailB: UIButton!

    var email: String?


    override func viewDidLoad() {
        super.viewDidLoad()

        print("Forgot View Controller Loaded!")

        if (email != nil) {
            if !(email?.isEmpty)! {
                registeredEmailTF.text = email
            }
        }

        requestMailB.layer.cornerRadius = 5
        requestMailB.layer.borderWidth = 1
        requestMailB.layer.borderColor = UIColor.clear.cgColor
        requestMailB.setTitleColor(UIColor.gray, for: .disabled)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = false
    }

    //MARK: Actions
    @IBAction func onClickRequest(_ sender: UIButton) {
        let email = registeredEmailTF.text

        if (email?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Email Cannot Be Empty.", presenter: self)
            return
        }

        if !(email?.contains("@"))! {
            Utils.showAlert(title: "Error!", message: "Invalid Email.", presenter: self)
            return
        }

        requestMail(email: email!)
    }

    func requestMail(email: String) {
        requestMailB.isEnabled = false

        print("\(email)")

        let url = URL(string: Utils.BASE_URL + "v2/forget")!
        let param: [String: String] = ["email": "\(email)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        self.requestMailB.isEnabled = true
                        print("Register Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                Utils.showAlertWithAction(title: "Mail Send!", message: "We have sent a reset password link via a mail to \(email).\nPlease follow the instruction in your email.", presenter: self)
                                Answers.logCustomEvent(withName: "Forgot Password", customAttributes: ["Email": email])
                            } else {
                                Utils.showAlert(title: "Status", message: serverResult!.status!, presenter: self)
                            }

                        }
                    case .failure:
                        self.requestMailB.isEnabled = true
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }
}
