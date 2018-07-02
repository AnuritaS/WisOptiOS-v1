// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import Kingfisher
import MobileCoreServices
import SwiftEventBus
import Crashlytics
import NVActivityIndicatorView

extension String {
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }

    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
}

class MessageViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var non_adminL: UILabel!


    @IBOutlet weak var messageView: UIView!

    @IBOutlet weak var messageTF: UITextView!
    @IBOutlet weak var sendB: UIButton!
    @IBOutlet weak var attachmentIV: UIImageView!

    var isAdmin: Bool? = nil

    var isNotification = false

    var group: Group?

    var selectedMessage: Announcements? = nil

    var messages = [Announcements]()
    var final = [MessageItem]()
    var reply_count = [Reply_count]()
    var imageUrl = String()


    lazy var refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        title = group?.subjectName

        if isNotification {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(MessageViewController.onClickDone))
            self.navigationItem.leftBarButtonItem = backButton
            self.checkIsLogin()
        }

        //assign cells to tableview
        tableView.register(MessageTableCell.self, forCellReuseIdentifier: "TextCell")
        tableView.register(MessageImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(MessageDocCell.self, forCellReuseIdentifier: "DocCell")
        tableView.register(MessageHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        SwiftEventBus.onMainThread(target as AnyObject, name: "notification") { result in
            // UI thread

            let email = Session.getString(forKey: Session.EMAIL)
            
            Answers.logCustomEvent(withName: "New Announcement Received", customAttributes: ["Email": email])
            self.getMessages()

        }


        self.replyUI()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.getMessages()

        let u_id = Session.getInteger(forKey: Session.ID)

        if (Session.getString(forKey: Session.PROFESSION) == "Professor" || u_id == group!.groupAdmin!) {
            isAdmin = true
        } else {
            isAdmin = false
        }

        if (!isAdmin!) {
            self.sendB.isHidden = true
            self.attachmentIV.isHidden = true
            self.messageTF.isHidden = true
            self.non_adminL.isHidden = false
        } else {
            self.non_adminL.isHidden = true
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onClickAttachment(tapGestureRecognizer:)))
        attachmentIV.isUserInteractionEnabled = true
        attachmentIV.addGestureRecognizer(tapGestureRecognizer)


        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getMessages), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func onClickDone() {
        print("on Click Done!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
        self.present(controller, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

    }


}


extension MessageViewController: UITableViewDelegate, UITableViewDataSource, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        return final.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return groups.count

        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked Row at position \(indexPath.section)")
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageItem = final[indexPath.section]
        //   let reply = reply_count[indexPath.section]
        if messageItem.type == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? MessageHeaderCell else {
                fatalError("The dequeued cell is not an instance of HeaderTableViewCell.")

            }

            cell.headerL.text = "\(messageItem.header!)"

            return cell
        } else if messageItem.type == 1 {
            let type = messageItem.message?.type
            let message = messageItem.message

            print(message!.messageId!, message!.type!, message!.message!)

            if (type == "0") {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? MessageTableCell else {
                    fatalError("The dequeued cell is not an instance of TextTableViewCell.")
                }
                cell.userL.text = message?.name
                cell.messageL.text = message?.message
                if (message?.unreadCount != 0) {
                    cell.countL.text = String(describing: message!.unreadCount)
                    cell.countL.isHidden = false
                } else {
                    cell.countL.isHidden = true
                }

                cell.messageL.dataDetectorTypes = .all
                if (isAdmin!) {
                    cell.onSeenTapped = {
                        print("Text Seen Tapped!")
                        self.openAcknowledgement(message: message!)
                    }
                } else {
                    cell.seen_symbol.isHidden = true
                    cell.seenL.isHidden = true
                }
                cell.onReplyTapped = {
                    print("Text reply tapped!")
                    self.openReply(message: message!)
                }
                let start = message?.time?.index((message?.time?.startIndex)!, offsetBy: 11)
                let end = message?.time?.index((message?.time?.startIndex)!, offsetBy: 16)
                cell.timeL.text = String(describing: message!.time![start!..<end!])


                return cell
            } else if type == "image" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? MessageImageCell else {
                    fatalError("The dequeued cell is not an instance of ImageTableViewCell.")
                }
                let iUrl = message!.message!
                let url = URL(string: iUrl)

                cell.imageIV.kf.setImage(with: url)
                cell.userL.text = message?.name
                if (message?.unreadCount != 0) {
                    cell.countL.text = String(describing: message!.unreadCount)
                    cell.countL.isHidden = false
                } else {
                    cell.countL.isHidden = true
                }
                if (isAdmin!) {
                    cell.onSeenTapped = {
                        print("Image Seen Tapped!")
                        self.openAcknowledgement(message: message!)
                    }
                } else {
                    cell.seen_symbol.isHidden = true
                    cell.seenL.isHidden = true
                }
                cell.onReplyTapped = {
                    print("Image reply tapped!")
                    self.openReplyImage(message: message!)
                }
                imageUrl = iUrl
                let start = message?.time?.index((message?.time?.startIndex)!, offsetBy: 11)
                let end = message?.time?.index((message?.time?.startIndex)!, offsetBy: 16)
                cell.timeL.text = String(describing: message!.time![start!..<end!])


                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocCell", for: indexPath) as? MessageDocCell else {
                    fatalError("The dequeued cell is not an instance of DocumentTableViewCell.")
                }

                cell.userL.text = message?.name
                cell.imageIV.image = #imageLiteral(resourceName:"docs")
                let start = message?.time?.index((message?.time?.startIndex)!, offsetBy: 11)
                let end = message?.time?.index((message?.time?.startIndex)!, offsetBy: 16)
                cell.timeL.text = String(describing: message!.time![start!..<end!])
                if (message?.unreadCount != 0) {
                    cell.countL.text = String(describing: message!.unreadCount)
                    cell.countL.isHidden = false
                } else {
                    cell.countL.isHidden = true
                }

                cell.imageIV.isUserInteractionEnabled = true
                cell.imageIV.tag = indexPath.section
                if (isAdmin!) {
                    cell.onSeenTapped = {
                        print("Doc Seen Tapped!")
                        self.openAcknowledgement(message: message!)
                    }
                } else {
                    cell.seen_symbol.isHidden = true
                    cell.seenL.isHidden = true
                }
                cell.onReplyTapped = {
                    print("Doc reply tapped!")
                    self.openReply(message: message!)
                }
                return cell
            }

        }

        guard let c = tableView.dequeueReusableCell(withIdentifier: "DocCell", for: indexPath) as? MessageDocCell else {
            fatalError("The dequeued cell is not an instance of DocumentTableViewCell.")
        }
        return c
    }

    //MARK: Other
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReplyVC") {
            //get a reference to the destination view controller
            let destinationVC = segue.destination as! ReplyViewController

            //set properties on the destination view controller
            destinationVC.message = selectedMessage
            destinationVC.group = group
            destinationVC.isText = selectedMessage?.type!
            //etc...
        } else if (segue.identifier == "imageVC") {
            let destinationVC = segue.destination as! EnlargeImageViewController
            destinationVC.message = selectedMessage
            destinationVC.group = group
            destinationVC.isText = selectedMessage?.type!
            //set properties on the destination view controller
            destinationVC.imageUrl = (selectedMessage?.message!)!
        } else if (segue.identifier == "infoVC") {
            let destinationVC = segue.destination as! InfoViewController

            //set properties on the destination view controller
            destinationVC.group = group
        }
    }

    @objc func getMessages() {
        let u_id = Session.getInteger(forKey: Session.ID)
        let g_id = group!.groupId!
        print("\(u_id) \(g_id)")

        let url = URL(string: Utils.BASE_URL + "v2/getannouncement")!
        let param: [String: String] = ["token": Session.getString(forKey: Session.TOKEN_CODE), "groupId": "\(g_id)", "userId": "\(u_id)"]
        //NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    switch response.result {
                    case .success:
                        print("Get Messages Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let getMessages = GetAnnouncements(JSONString: utf8Text)
                            let messages = getMessages?.messages
                            let replies_count = getMessages?.reply_count

                            //print(utf8Text)

                            self.messages.removeAll()

                            for i in messages! {
                                for j in replies_count! {
                                    if (i.messageId! == j.reply_on_ann!) {
                                        i.unreadCount = j.count!
                                        break
                                    }
                                }
                            }

                            self.messages.append(contentsOf: messages!)
                            self.reloadTableView()

                        }
                    case .failure:
                        print("Error Ocurred!")

                        let alert = UIAlertController(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", preferredStyle: UIAlertControllerStyle.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                            action in
                            if (action.style == .default) {
                                self.getMessages()
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

    func reloadTableView() {
        DispatchQueue.main.async {

            self.final.removeAll()

            if (self.messages.count > 0) {
                //print("\(self.messages.count)")

                for i in 0..<self.messages.count {
                    let m = self.messages[i]
                    let index = m.time!.index(m.time!.startIndex, offsetBy: 10)
                    let date = String(m.time![..<index])
                    if (self.final.count == 0) {
                        self.final.append(MessageItem(header: date))
                    } else {
                        let ind = self.final[self.final.count - 1].message!.time?.index(self.final[self.final.count - 1].message!.time!.startIndex, offsetBy: 10)
                        if (String(self.final[self.final.count - 1].message!.time![..<ind!]) != date) {
                            self.final.append(MessageItem(header: date))
                        }
                    }
                    self.final.append(MessageItem(message: m))

                }

                print("Refreshing data")
                self.tableView.reloadData()
            } else {
                print("No Messages Yet!")
            }
            if (self.tableView.refreshControl?.isRefreshing)! {
                Constant().anime(self.tableView)
            }
        }
    }

    //MARK: Action
    @IBAction func sendMessage(_ sender: UIButton) {
        let message = messageTF.text
        let g_id = group!.groupId!
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        print(dateString)

        if !(message?.isEmpty)! {
            sendB.isEnabled = false

            let url = URL(string: Utils.BASE_URL + "v2/send")!
            let tc = Session.getString(forKey: Session.TOKEN_CODE)

            let param: [String: String] = ["userId": String(Session.getInteger(forKey: Session.ID)), "token": tc, "groupId": "\(g_id)", "message": "\(message!)", "time": "\(dateString)"]

            Alamofire.request(url, method: .post, parameters: param)
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            self.sendB.isEnabled = true
                            print("Send Announcement Successful!")

                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                let serverResult = ServerResult(JSONString: utf8Text)

                                print(serverResult!.status!)

                                if serverResult!.status! == "true" {
                                    self.messageTF.text = ""

                                    let email = Session.getString(forKey: Session.EMAIL)
                                    
                                    Answers.logCustomEvent(withName: "New Announcement Added", customAttributes: ["Email": email])

                                    self.getMessages()
                                } else {
                                    Utils.showAlert(title: "Error", message: serverResult!.status!, presenter: self)
                                }

                            }
                        case .failure:
                            self.sendB.isEnabled = true
                            print("Error Ocurred!")

                            Utils.showAlert(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", presenter: self)
                        }
                    }
        }

    }

    @objc func onClickAttachment(tapGestureRecognizer: UITapGestureRecognizer) {
        // create the alert

        print("Clicked!")
        let alert = UIAlertController(title: "Add Attachment", message: "Select type of attachment!", preferredStyle: UIAlertControllerStyle.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "Image", style: UIAlertActionStyle.default, handler: {
            action in
            if (action.style == .default) {
                print("Image")
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))

        alert.addAction(UIAlertAction(title: "Document", style: UIAlertActionStyle.default, handler: {
            action in
            if (action.style == .default) {
                print("Document")
                let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc", "com.microsoft.powerpoint.​ppt", "com.microsoft.excel.xls", String(kUTTypePlainText)], in: .import)
                importMenu.delegate = self
                importMenu.modalPresentationStyle = .formSheet
                self.present(importMenu, animated: true, completion: nil)
            }
        }))
        /* alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {
         action in
         if(action.style == .default){
         print("Camera")
         
         let imagePickerController = UIImagePickerController()
         imagePickerController.mediaTypes = [String(kUTTypeImage)]
         imagePickerController.sourceType = .camera
         imagePickerController.delegate = self
         self.present(imagePickerController, animated: true, completion: nil)
         }
         }))*/
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            action in
            if (action.style == .cancel) {
                print("Cancel")
            }
        }))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.

        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }


        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        guard let imageData = selectedImage.jpeg(.lowest) else {
            print("Cannot compress image")
            return
        }
        print("Image compress count", imageData.count)
        //let imageData = UIImagePNGRepresentation(selectedImage)!
        //put in a separate file
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)


        Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData, withName: "message", fileName: "123.png", mimeType: "multipart/form-data")
                    multipartFormData.append(String(self.group!.groupId!).data(using: String.Encoding.utf8)!, withName: "groupId")
                    multipartFormData.append(dateString.data(using: String.Encoding.utf8)!, withName: "time")
                    multipartFormData.append(Session.getString(forKey: Session.TOKEN_CODE).data(using: String.Encoding.utf8)!, withName: "token")
                    multipartFormData.append(String(Session.getInteger(forKey: Session.ID)).data(using: String.Encoding.utf8)!, withName: "userId")
                },
                to: Utils.BASE_URL + "v2/send/file",
                encodingCompletion: { encodingResult in

                    switch encodingResult {

                    case .success(let upload, _, _):
                        upload.uploadProgress { progress in

                            let alertView = UIAlertController(title: "Please wait", message: "Upload progress!", preferredStyle: .alert)
                            //  Show it to your users
                            alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {
                                action in
                                if (action.style == .cancel) {
                                    print("Cancel")
                                }
                            }))
                            self.present(alertView, animated: true, completion: {
                                print("PROGRESS", progress.fractionCompleted)
                                //  Add your progressbar after alert is shown (and measured)
                                let margin: CGFloat = 8.0
                                let rect = CGRect(x: margin, y: 72.0, width: alertView.view.frame.width - margin * 2.0, height: 2.0)
                                let progressView = UIProgressView(frame: rect)
                                DispatchQueue.main.async {
                                    progressView.progress = Float(progress.fractionCompleted)
                                }
                                progressView.tintColor = UIColor.yellow
                                alertView.view.addSubview(progressView)
                            })


                        }
                        upload.responseJSON { response in
                            debugPrint(response)

                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {

                                let email = Session.getString(forKey: Session.EMAIL)
                                Answers.logCustomEvent(withName: "New Photo Added", customAttributes: ["Email": email])

                                self.getMessages()
                                self.dismiss(animated: true, completion: nil)

                            }
                        }

                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
        )

    }


    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL

        let exten = Utils.getExtension(url: cico.relativeString)
        print("extension", exten)
        print("isSupported", Utils.isSupportedDocumentType(ext: exten))

        if Utils.isSupportedDocumentType(ext: exten) {
            print("The Url is : \(cico)")
            self.dismiss(animated: true, completion: nil)
            let fileName = cico.lastPathComponent

            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: date as Date)

            Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(cico, withName: "message", fileName: "\(fileName)", mimeType: "multipart/form-data")
                        multipartFormData.append(String(self.group!.groupId!).data(using: String.Encoding.utf8)!, withName: "groupId")
                        multipartFormData.append(dateString.data(using: String.Encoding.utf8)!, withName: "time")
                        multipartFormData.append(Session.getString(forKey: Session.TOKEN_CODE).data(using: String.Encoding.utf8)!, withName: "token")
                        multipartFormData.append(String(Session.getInteger(forKey: Session.ID)).data(using: String.Encoding.utf8)!, withName: "userId")

                    },
                    to: Utils.BASE_URL + "v2/send/file",
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.uploadProgress { progress in

                                let alertView = UIAlertController(title: "Please wait", message: "Upload progress!", preferredStyle: .alert)
                                //  Show it to your users
                                alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {
                                    action in
                                    if (action.style == .cancel) {
                                        print("Cancel")
                                    }
                                }))
                                self.present(alertView, animated: true, completion: {
                                    //  Add your progressbar after alert is shown (and measured)
                                    let margin: CGFloat = 8.0
                                    let rect = CGRect(x: margin, y: 72.0, width: alertView.view.frame.width - margin * 2.0, height: 2.0)
                                    let progressView = UIProgressView(frame: rect)
                                    DispatchQueue.main.async {
                                        progressView.progress = Float(progress.fractionCompleted)
                                        //print("File Upload Progress: ", progress.fractionCompleted,
                                        //    progress.isFinished)
                                    }
                                    progressView.tintColor = UIColor.yellow
                                    alertView.view.addSubview(progressView)
                                })


                            }
                            upload.responseJSON { response in
                                debugPrint(response)

                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    let serverResult = ServerResult(JSONString: utf8Text)
                                    let status = serverResult?.status

                                    print("\(String(describing: status))")

                                    let email = Session.getString(forKey: Session.EMAIL)
                                    Answers.logCustomEvent(withName: "New Document Added", customAttributes: ["Email": email])

                                    self.getMessages()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }

                        case .failure(let encodingError):
                            print(encodingError)
                        }
                    }
            )
        } else {
            Utils.showAlert(title: "Not Supported", message: "Sorry, We don't support \(exten) extension.", presenter: self)
        }
    }

    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {

        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)

    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

        print("we cancelled")

        dismiss(animated: true, completion: nil)

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


extension MessageViewController {
    func openAcknowledgement(message: Announcements) {

        let controller = AcknowledgementViewController()

        controller.message = message
        controller.group = group
        controller.isText = message.type!

        self.navigationController!.pushViewController(controller, animated: false)

    }

    func openReply(message: Announcements) {
        selectedMessage = message
        performSegue(withIdentifier: "ReplyVC", sender: self)
    }

    func openReplyImage(message: Announcements) {
        selectedMessage = message
        performSegue(withIdentifier: "imageVC", sender: self)
    }

    func replyUI() {
        messageView.layer.shadowColor = UIColor.black.cgColor
        messageView.layer.shadowOpacity = 0.2
        messageView.layer.shadowRadius = 10

        attachmentIV.layer.shadowColor = UIColor.black.cgColor
        attachmentIV.layer.shadowOpacity = 0.5
        attachmentIV.layer.shadowRadius = 3
        attachmentIV.layer.shadowOffset = CGSize(width: 2, height: 2)

        sendB.layer.shadowColor = UIColor(rgb: 0x476ae8).cgColor
        sendB.layer.shadowOpacity = 0.5
        sendB.layer.shadowRadius = 3
        sendB.layer.shadowOffset = CGSize(width: 2, height: 2)

        messageTF.layer.cornerRadius = 10
        messageTF.layer.borderWidth = 1
        messageTF.layer.borderColor = UIColor.clear.cgColor

    }
}
