// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import FirebaseMessaging
import Crashlytics

class SettingsViewController: UIViewController {

    lazy var myTableView: UITableView = {
        let view = UITableView()

        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsetsMake(100, 0, 0, 100)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.bounces = false

        return view
    }()
    let photos = [#imageLiteral(resourceName:"reset-password"), #imageLiteral(resourceName:"contact"), #imageLiteral(resourceName:"logout-button")]
    let options = ["Reset Password", "Contact US", "Logout"]

    override func viewDidLoad() {
        view.backgroundColor = UIColor(rgb: 0xffffff)
        super.viewDidLoad()
        myTableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {

        view.addSubview(myTableView)
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        cell.photo_icon.image = photos[indexPath.row]
        cell.value.text = options[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 67
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ForgotVC")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ContactVC")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 2 {
            self.onClickLogout()
        }
    }
}

extension SettingsViewController {


    func onClickLogout() {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        let alert = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {

            action in
            UIApplication.shared.beginIgnoringInteractionEvents()
            if (action.style == .default) {
                if (token != nil) {
                    self.removeToken(token: token!)
                } else {
                    self.setIsLogout()
                    self.checkIsLogin()
                }
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

    func removeToken(token: String) {
        let url = URL(string: Utils.BASE_URL + "v2/device/remove")!
        let param: [String: String] = ["token": "\(token)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    UIApplication.shared.endIgnoringInteractionEvents()
                    switch response.result {
                    case .success:

                        print("Logout Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                            if serverResult!.status! == "true" {
                                self.setIsLogout()

                                let email = Session.getString(forKey: Session.EMAIL)
                                Answers.logCustomEvent(withName: "User Logout", customAttributes: ["Email": email])

                                self.checkIsLogin()
                            } else {
                                Utils.showAlert(title: "Error", message: "Try Again! \(serverResult!.status!)", presenter: self)
                            }

                        }
                    case .failure:
                        print("Error Ocurred!")

                        Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                    }
                }
    }

    func setIsLogout() {
        Session.set(value: false, forKey: "IS_LOGIN")
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
}
