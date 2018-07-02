// WisOpt copyright Monkwish 2017

import UIKit
import Crashlytics
import MessageUI

class DetailsViewController: UIViewController {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var faculty_nameL: UILabel!
    @IBOutlet weak var facId_deptL: UILabel!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var subCode: UILabel!
    @IBOutlet weak var startT: UILabel!
    @IBOutlet weak var endT: UILabel!
    @IBOutlet weak var prog: UILabel!
    @IBOutlet weak var sem: UILabel!
    @IBOutlet weak var roomN: UILabel!
    @IBOutlet weak var block: UILabel!
    @IBOutlet weak var dayO: UILabel!
    @IBOutlet weak var slot: UILabel!
    @IBOutlet weak var callB: UIButton!
    @IBOutlet weak var mailB: UIButton!

    var details: RoomDetail? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Details View Controller Loaded")

        title = "Room Details"

        self.facultyDetails()
        self.setupView()
    }

    func facultyDetails() {

        faculty_nameL.text = details?.facultyName!
        facId_deptL.text = "\(String(describing: details!.facultyId!)), \(String(describing: details!.offeringDepartment!))"
        subName.text = "\(String(describing: details!.courseTitle!))"
        subCode.text = "\(String(describing: details!.courseCodeTitle!))"
        startT.text = "\(String(describing: details!.classFrom!))"
        endT.text = "\(String(describing: details!.classTo!))"
        prog.text = "\(String(describing: details!.program!))"
        sem.text = "\(String(describing: details!.semester!))"
        roomN.text = "\(String(describing: details!.classRoom!))"
        block.text = "\(String(describing: details!.block!))"
        dayO.text = "\(String(describing: details!.tDayOrder!))"
        slot.text = "\(String(describing: details!.slot!))"

        if (details?.mobile?.count != 10) {
            callB.isEnabled = false
        } else {
            callB.isEnabled = true
        }

    }

    func setupView() {
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.2
        myView.layer.shadowRadius = 5

        callB.layer.cornerRadius = 5
        callB.layer.borderWidth = 1
        callB.layer.borderColor = UIColor.clear.cgColor

        mailB.layer.cornerRadius = 5
        mailB.layer.borderWidth = 1
        mailB.layer.borderColor = UIColor.clear.cgColor
    }
}


extension DetailsViewController: MFMailComposeViewControllerDelegate {
    @IBAction func callButton(_ sender: UIButton) {
        if let url = URL(string: "tel://\(details!.mobile!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            let email = Session.getString(forKey: Session.EMAIL)
            Answers.logCustomEvent(withName: "Call Button Tapped", customAttributes: ["Email": email])
        }
    }

    @IBAction func mailButton(_ sender: UIButton) {
        let email = details!.officialEmail!
        if email != "" {
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        Answers.logCustomEvent(withName: "Mail Button Tapped", customAttributes: ["Email": email])
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setSubject("Room Enquiry")

        return mailComposerVC
    }

    func showSendMailErrorAlert() {
        Utils.showAlert(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", presenter: self)
    }

    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
