// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var loginB: UIButton!

    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var emailLine: UIView!

    var loginPresenter: LoginPresenter?

    override func viewDidLoad() {

        super.viewDidLoad()

        checkIsLogin()

        if (emailTF != nil && passwordTF != nil) {
            emailTF.delegate = self
            passwordTF.delegate = self
        }

        if loginB != nil {
            buttonView()
        }

        showPassword()

        loginPresenter = LoginPresenter(loginView: self)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = true
    }


    //MARK: Actions
    @IBAction func onClickLogin(_ sender: UIButton) {
        let email = emailTF.text
        let password = passwordTF.text

        if (email?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Email Cannot Be Empty.", presenter: self)
            return
        }

        if (password?.isEmpty)! {
            Utils.showAlert(title: "Error!", message: "Password Cannot Be Empty.", presenter: self)
            return
        }

        if ((password?.count)! < 6) {
            Utils.showAlert(title: "Error!", message: "Minimum password length is 6.", presenter: self)
            return
        }

        loginUser(email: email!, password: password!)
    }

    //MARK: Other Functions

    func loginUser(email: String, password: String) {
        loginB.isEnabled = false
        loginPresenter?.loginUser(email: email, password: password)
    }

    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ViewController {

    func showPassword() {
        let remember = Session.getBool(forKey: Session.REMEMBER)

        if (emailTF != nil && passwordTF != nil) {
            if (remember) {
                emailTF.text = Session.getString(forKey: Session.EMAIL)
                passwordTF.text = Session.getString(forKey: Session.PASSWORD)
            }
        }
    }

    func buttonView() {

        loginB.layer.cornerRadius = 10
        loginB.layer.borderWidth = 1
        loginB.layer.borderColor = UIColor.clear.cgColor
        loginB.setTitleColor(UIColor.gray, for: .disabled)

        /* registerB.layer.cornerRadius = 5
         registerB.layer.borderWidth = 1
         registerB.layer.borderColor = UIColor.clear.cgColor*/
    }

    func showUserDetails() {
        print("ID: \(Session.getInteger(forKey: Session.ID))")
        print("NAME: \(Session.getString(forKey: Session.NAME))")
        print("REG_ID: \(Session.getString(forKey: Session.REG_ID))")
        print("GENDER: \(Session.getString(forKey: Session.GENDER))")
        print("EMAIL: \(Session.getString(forKey: Session.EMAIL)))")
        print("UNIVERSITY: \(Session.getString(forKey: Session.UNIVERSITY))")
        print("PROFESSION: \(Session.getString(forKey: Session.PROFESSION))")
        print("PASSWORD: \(Session.getString(forKey: Session.PASSWORD))")
        print("TOKEN_CODE: \(Session.getString(forKey: Session.TOKEN_CODE))")

    }

    func deleteUserDetails() {
        Session.removeObject(forKey: Session.ID)
        Session.removeObject(forKey: Session.NAME)

        print("ID: \(Session.getInteger(forKey: Session.ID))")
        print("NAME: \(Session.getString(forKey: Session.NAME))")
    }
}

extension ViewController: LoginView {
    func onNextLogin() {
        self.loginB.isEnabled = true
    }

    func onErrorLogin() {
        self.loginB.isEnabled = true
    }

    func onCompleteLogin() {

    }

    func checkIsLogin() {
        if (emailTF != nil && passwordTF != nil && loginB != nil) {

            let IS_LOGIN = Session.getBool(forKey: Session.IS_LOGIN)
            print("IS_LOGIN: \(IS_LOGIN)")

            if (IS_LOGIN) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

    func setIsLogin() {
        Session.set(value: true, forKey: "IS_LOGIN")
    }

    func present(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        Utils.showAlert(title: title, message: message, presenter: self)
    }
}

extension ViewController: UITextFieldDelegate {


    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTF {
            emailLine.backgroundColor = UIColor(rgb: 0x476ae8)
        }
        if textField == passwordTF {
            passwordLine.backgroundColor = UIColor(rgb: 0x476ae8)
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF {
            emailLine.backgroundColor = UIColor(rgb: 0x000000)
        }
        if textField == passwordTF {
            passwordLine.backgroundColor = UIColor(rgb: 0x000000)
        }
    }

}
