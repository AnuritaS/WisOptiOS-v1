//
//  LoginPresenter.swift
//  WisOpt
//
//  Created by WisOpt MacBook on 06/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import Alamofire
import Crashlytics

class LoginPresenter {
    let loginView: LoginView

    init(loginView: LoginView) {
        self.loginView = loginView
    }

    func loginUser(email: String, password: String) {
        print("Email: \(email), Password: \(password)")

        let url = URL(string: Utils.BASE_URL + "v2/login")!
        let param: [String: String] = ["email": "\(email)", "password": "\(password)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    //print("All Response Info: \(response)")
                    //print("Request: \(String(describing: response.request))")   // original url request
                    //print("Response: \(String(describing: response.response))") // http url response

                    //print("Result: \(response.result)")                         // response serialization result
                    //print("Error: \(response.error)")

                    //print("Success: \(response.result.isSuccess)")
                    //print("Failure: \(response.result.isFailure)")

                    switch response.result {
                    case .success:
                        self.loginView.onNextLogin()

                        print("Login Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            //print("Data: \(utf8Text)") // original server data as UTF8 string

                            let serverResult = ServerResult(JSONString: utf8Text)
                            self.processLogin(serverResult: serverResult, password: password)
                        }
                    case .failure:
                        print("Error Ocurred!")
                        self.loginView.onErrorLogin()
                        self.loginView.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.")
                    }
                }
    }
}

extension LoginPresenter {
    func processLogin(serverResult: ServerResult?, password: String) {
        print(serverResult!.status!)

        if serverResult!.status! == "success" {

            let stud: Bool = (serverResult!.userData!.profession! == "Student")
            Utils.stud = stud
            Answers.logLogin(withMethod: "Login",
                    success: true,
                    customAttributes: ["Name": serverResult!.userData!.name!, "Email": serverResult!.userData!.email!, "Profession": serverResult!.userData!.profession!])

            let alert = UIAlertController(title: "Remember", message: "Do you want to save the password?", preferredStyle: UIAlertControllerStyle.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                action in
                if (action.style == .default) {
                    self.storeUserData(user: serverResult!.userData!, password: password, remember: true)
                    if (stud) {
                        self.storeUserDetail(user: serverResult!.userDetail!)
                    }
                    self.loginView.setIsLogin()
                    self.loginView.checkIsLogin()
                    Answers.logCustomEvent(withName: "Remembered Password",
                            customAttributes: ["Name": serverResult!.userData!.name!, "Email": serverResult!.userData!.email!, "Profession": serverResult!.userData!.profession!])
                }
            }))

            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {
                action in
                if (action.style == .cancel) {
                    self.storeUserData(user: serverResult!.userData!, password: password, remember: false)
                    if (stud) {
                        self.storeUserDetail(user: serverResult!.userDetail!)
                    }
                    self.loginView.setIsLogin()
                    self.loginView.checkIsLogin()
                    Answers.logCustomEvent(withName: "Not Remembered Password",
                            customAttributes: ["Name": serverResult!.userData!.name!, "Email": serverResult!.userData!.email!, "Profession": serverResult!.userData!.profession!])
                }
            }))

            // show the alert
            self.loginView.present(alert: alert)

        } else {
            self.loginView.showAlert(title: "Error", message: serverResult!.status!)
            Answers.logLogin(withMethod: "Login",
                    success: false,
                    customAttributes: nil)
        }
    }
}

extension LoginPresenter {
    func storeUserData(user: User, password: String, remember: Bool) {
        Session.set(value: user.id!, forKey: Session.ID)
        Session.set(value: user.name!, forKey: Session.NAME)
        Session.set(value: user.regId!, forKey: Session.REG_ID)
        Session.set(value: user.gender!, forKey: Session.GENDER)
        Session.set(value: user.email!, forKey: Session.EMAIL)
        Session.set(value: user.university!, forKey: Session.UNIVERSITY)
        Session.set(value: user.profession!, forKey: Session.PROFESSION)
        Session.set(value: user.token_code!, forKey: Session.TOKEN_CODE)
        Session.set(value: password, forKey: Session.PASSWORD)
        Session.set(value: remember, forKey: Session.REMEMBER)
        Session.set(value: user.department!, forKey: Session.DEPARTMENT)
        if (user.profession! == "Student") {
            Session.set(value: user.year!, forKey: Session.YEAR)
        }
    }

    func storeUserDetail(user: Detail) {
        Session.set(value: user.classInchargeId!, forKey: Session.CI_ID)
        Session.set(value: user.classInchargeName!, forKey: Session.CI_NAME)
        Session.set(value: user.yearCoordinatorId!, forKey: Session.YC_ID)
        Session.set(value: user.yearCoordinatorName!, forKey: Session.YC_NAME)
    }
}
