// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import Kingfisher
import SwiftEventBus
import Crashlytics
import MobileCoreServices

class ReplyViewController: UIViewController, UIDocumentInteractionControllerDelegate, UIScrollViewDelegate {

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyTF: UITextView!
    @IBOutlet weak var sendB: UIButton!
    @IBOutlet weak var messageL: UITextView!
    @IBOutlet weak var messageImageIV: UIImageView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var attachB: UIButton!


    var message: Announcements?
    var group: Group?
    var isText: String?

    var replies = [Reply]()
    var final = [MessageItem]()

    var selectedReply: Reply? = nil

    var id = ""
    var exten = ""
    var url = ""

    var r_id = ""
    var r_exten = ""
    var r_url = ""

    var isNotification = false

    var documentInteractionController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        if isNotification {
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(ReplyViewController.onClickDone))
            self.navigationItem.leftBarButtonItem = backButton
            self.checkIsLogin()
        }

        //self.edgesForExtendedLayout = []
        SwiftEventBus.onMainThread(target as AnyObject, name: "notification") { result in
            // UI thread
            let email = Session.getString(forKey: Session.EMAIL)
            Answers.logCustomEvent(withName: "New Reply Received", customAttributes: ["Email": email])
            self.getReplies()
        }
        edgesForExtendedLayout = UIRectEdge.bottom

        messageL.dataDetectorTypes = .all

        print("ReplyViewController Added!")

        self.replyUI()

        title = "Reply"

        if (isText == "image") {
            messageL.isHidden = true
            messageImageIV.isHidden = true
        } else if isText == "0" {
            messageL.isHidden = false
            messageImageIV.isHidden = true
            messageL.text = message!.message
        } else {
            messageImageIV.isHidden = false
            messageImageIV.image = #imageLiteral(resourceName:"document-download")
            messageL.backgroundColor = UIColor(rgb: 0xffffff)

            id = String(describing: message!.messageId!)
            exten = message!.type!
            url = message!.message!

            messageL.text = (url as NSString).lastPathComponent
            let tapped = UITapGestureRecognizer(target: self, action: #selector(self.onDocClicked))
            tapped.numberOfTapsRequired = 1
            messageImageIV.isUserInteractionEnabled = true

            messageImageIV.addGestureRecognizer(tapped)

        }

        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(MessageHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.register(ReplyTextCell.self, forCellReuseIdentifier: "ReplyCell")
        tableView.register(MessageImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(MessageDocCell.self, forCellReuseIdentifier: "DocCell")
        self.getReplies()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension

    }


    @IBAction func clickOnAttach(_ sender: Any) {
        print("on clik reply attachment!")
        self.sendAttach()

    }

    @objc func onClickDone() {
        print("on Click Done!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
        self.present(controller, animated: true, completion: nil)
    }


    @objc func onDocClicked() {
        print("Document Clicked!")

        print("id: \(id)")
        print("exten: \(exten)")
        print("url: \(url)")

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("WisOpt/Documents/groupDocument\(id).\(exten)")

        print(fileURL.relativeString)

        let checkValidation = FileManager.default

        if (checkValidation.fileExists(atPath: fileURL.relativePath)) {
            print("DOCUMENT AVAILABLE");

            documentInteractionController = UIDocumentInteractionController(url: fileURL)
            documentInteractionController?.delegate = self
            documentInteractionController?.presentPreview(animated: true)

        } else {
            print("DOCUMENT NOT AVAILABLE");
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("WisOpt/Documents/groupDocument\(self.id).\(self.exten)")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }

            Alamofire.download(url, to: destination).response { response in

                if response.error == nil, let imagePath = response.destinationURL?.relativePath {
                    print(imagePath)

                    self.onDocClicked()
                } else {
                    print("Error Ocurred! \(String(describing: response.error))")
                }

            }.downloadProgress { progress in

                let alertView = UIAlertController(title: "Please wait", message: "Download progress!", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                //change this later with help from server
                //  Show it to your users
                self.present(alertView, animated: true, completion: {

                    //  Add your progressbar after alert is shown (and measured)
                    let margin: CGFloat = 8.0
                    let rect = CGRect(x: margin, y: 72.0, width: alertView.view.frame.width - margin * 2.0, height: 2.0)
                    let progressView = UIProgressView(frame: rect)
                    progressView.progress = Float(progress.fractionCompleted)
                    progressView.trackTintColor = UIColor.yellow
                    //progressView.tintColor = UIColor.blue
                    alertView.view.addSubview(progressView)

                })
                self.messageL.textAlignment = .center
                self.messageL.text = "Downloaded. Click to open! "

            }
        }
    }

    func onReplyDocClicked() {
        print("Document Clicked!")

        print("id: \(r_id)")
        print("exten: \(r_exten)")
        print("url: \(r_url)")

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("WisOpt/ReplyDocs/replyDocument\(r_id).\(r_exten)")

        print(fileURL.relativeString)

        let checkValidation = FileManager.default

        if (checkValidation.fileExists(atPath: fileURL.relativePath)) {
            print("DOCUMENT AVAILABLE");

            documentInteractionController = UIDocumentInteractionController(url: fileURL)
            documentInteractionController?.delegate = self
            documentInteractionController?.presentPreview(animated: true)

        } else {
            print("DOCUMENT NOT AVAILABLE");
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("WisOpt/ReplyDocs/replyDocument\(self.r_id).\(self.r_exten)")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }

            Alamofire.download(r_url, to: destination).response { response in

                if response.error == nil, let imagePath = response.destinationURL?.relativePath {
                    print(imagePath)

                    self.onReplyDocClicked()
                } else {
                    print("Error Ocurred! \(String(describing: response.error))")
                }

            }.downloadProgress { progress in

                let alertView = UIAlertController(title: "Please wait", message: "Download progress!", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                //change this later with help from server
                //  Show it to your users
                self.present(alertView, animated: true, completion: {

                    //  Add your progressbar after alert is shown (and measured)
                    let margin: CGFloat = 8.0
                    let rect = CGRect(x: margin, y: 72.0, width: alertView.view.frame.width - margin * 2.0, height: 2.0)
                    let progressView = UIProgressView(frame: rect)
                    progressView.progress = Float(progress.fractionCompleted)
                    progressView.trackTintColor = UIColor.yellow
                    //progressView.tintColor = UIColor.blue
                    alertView.view.addSubview(progressView)

                })

            }
        }
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
    }

    //MARK: Other
    func getReplies() {
        let message_id = message!.messageId!

        let url = URL(string: Utils.BASE_URL + "v2/getreply")!
        let tc = Session.getString(forKey: Session.TOKEN_CODE)

        let param: [String: String] = ["userId": String(describing: Session.getInteger(forKey: Session.ID)), "token": tc, "messageId": "\(message_id)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Get Reply Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let getReply = ReplyResult(JSONString: utf8Text)
                            let replies = getReply?.replies

                            self.replies.removeAll()
                            for r in replies! {
                                self.replies.insert(r, at: 0)
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
                                self.getReplies()
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

            if (self.replies.count > 0) {
                //print("\(self.messages.count)")

                for i in 0..<self.replies.count {
                    let r = self.replies[i]
                    let index = r.time!.index(r.time!.startIndex, offsetBy: 10)
                    let date = String(r.time![..<index])
                    if (self.final.count == 0) {
                        self.final.append(MessageItem(header: date))
                    } else {
                        let ind = self.final[self.final.count - 1].reply!.time?.index(self.final[self.final.count - 1].reply!.time!.startIndex, offsetBy: 10)
                        if (String(self.final[self.final.count - 1].reply!.time![..<ind!]) != date) {
                            self.final.append(MessageItem(header: date))
                        }
                    }
                    self.final.append(MessageItem(reply: r))


                }

                //print("\(self.final.count)")

                print("Refreshing data")
                self.tableView.reloadData()
            } else {
                print("No Replies Yet!")
            }

        }
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

    //MARK: Action
    @IBAction func sendReply(_ sender: UIButton) {
        let reply = replyTF.text
        let g_id = group!.groupId!
        let a_id = message!.messageId!

        let u_id = Session.getInteger(forKey: Session.ID)

        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date as Date)
        print(dateString)
        print("\(String(describing: reply))")

        if !(reply?.isEmpty)! {
            sendB.isEnabled = false

            let url = URL(string: Utils.BASE_URL + "v2/reply")!
            let tc = Session.getString(forKey: Session.TOKEN_CODE)
            
            let param: [String: String] = ["token": tc, "a_id": "\(a_id)", "group_id": "\(g_id)", "u_id": "\(u_id)", "message": "\(reply!)", "time": "\(dateString)"]

            Alamofire.request(url, method: .post, parameters: param)
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            self.sendB.isEnabled = true
                            print("Send Reply Successful!")

                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                let serverResult = ServerResult(JSONString: utf8Text)

                                print(serverResult!.status!)

                                if serverResult!.status! == "true" {
                                    self.replyTF.text = ""

                                    let email = Session.getString(forKey: Session.EMAIL)
                                    if u_id == self.group?.groupAdmin! {
                                        Answers.logCustomEvent(withName: "New Reply Added by Admin", customAttributes: ["Email": email])
                                    } else {
                                        Answers.logCustomEvent(withName: "New Reply Added", customAttributes: ["Email": email])
                                    }

                                    self.getReplies()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "imageRVC") {
            print("Doing seague")
            let destinationVC = segue.destination as! EnlargeImageViewController
            destinationVC.reply = selectedReply!
            destinationVC.isReply = true
            destinationVC.group = group
            destinationVC.isText = selectedReply!.r_type!
            //set properties on the destination view controller
            destinationVC.imageUrl = (selectedReply!.message!)
        }
    }

}

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return final.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked Row at position \(indexPath.section)")

        let replyItem = final[indexPath.section]

        if (replyItem.type == replyItem.REPLY) {

            let reply = replyItem.reply!

            if (reply.r_type! == "image") {
                selectedReply = reply
                print("Perform Seague")
                performSegue(withIdentifier: "imageRVC", sender: self)
            } else if (reply.r_type! != "0") {
                r_id = String(reply.replyId!)
                r_exten = reply.r_type!
                r_url = reply.message!
                onReplyDocClicked()
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageItem = final[indexPath.section]

        if messageItem.type == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? MessageHeaderCell else {
                fatalError("The dequeued cell is not an instance of HeaderTableViewCell.")
            }

            cell.headerL.text = "\(messageItem.header!)"
            return cell
        } else if messageItem.type == 2 {
            let reply = messageItem.reply
            let type = reply!.r_type!
            print(type)

            if (type == "0") {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as? ReplyTextCell else {
                    fatalError("The dequeued cell is not an instance of TextTableViewCell.")
                }
                cell.userL.text = "\(reply!.name!) \n \(reply!.reg_id!)"
                cell.messageL.text = reply?.message

                cell.messageL.dataDetectorTypes = .all
                let start = reply?.time?.index((reply?.time?.startIndex)!, offsetBy: 11)
                let end = reply?.time?.index((reply?.time?.startIndex)!, offsetBy: 16)
                cell.timeL.text = String(describing: reply!.time![start!..<end!])
                return cell
            } else if (type == "image") {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? MessageImageCell else {
                    fatalError("The dequeued cell is not an instance of ImageTableViewCell.")
                }
                let iUrl = reply!.message!
                let url = URL(string: iUrl)
                print("\(url!.absoluteString)")
                cell.imageIV.kf.setImage(with: url)
                cell.userL.text = "\(reply!.name!) \n \(reply!.reg_id!)"

                cell.countL.isHidden = true
                cell.seen_symbol.isHidden = true
                cell.seenL.isHidden = true
                cell.replyL.isHidden = true
                cell.reply_symbol.isHidden = true

                let start = reply?.time?.index((reply?.time?.startIndex)!, offsetBy: 11)
                let end = reply?.time?.index((reply?.time?.startIndex)!, offsetBy: 16)
                cell.timeL.text = String(describing: reply!.time![start!..<end!])


                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocCell", for: indexPath) as? MessageDocCell else {
                    fatalError("The dequeued cell is not an instance of DocumentTableViewCell.")
                }

                cell.userL.text = "\(reply!.name!) \n \(reply!.reg_id!)"
                cell.imageIV.image = #imageLiteral(resourceName:"docs")

                let start = reply?.time?.index((reply?.time?.startIndex)!, offsetBy: 11)
                let end = reply?.time?.index((reply?.time?.startIndex)!, offsetBy: 16)
                cell.timeL.text = String(describing: reply!.time![start!..<end!])


                cell.countL.isHidden = true
                cell.replyL.isHidden = true
                cell.reply_symbol.isHidden = true
                cell.seen_symbol.isHidden = true
                cell.seenL.isHidden = true

                cell.imageIV.isUserInteractionEnabled = true
                cell.imageIV.tag = indexPath.section

                return cell
            }
        }


        guard let c = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as? ReplyTextCell else {
            fatalError("The dequeued cell is not an instance of DocumentTableViewCell.")
        }
        return c
    }
}

extension ReplyViewController: UIDocumentMenuDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func sendAttach() {

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
                let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc", "com.microsoft.powerpoint.​ppt", "com.microsoft.excel.xls", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", String(kUTTypePlainText)], in: .import)
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
                    multipartFormData.append(String(describing: self.message!.messageId!).data(using: String.Encoding.utf8)!, withName: "a_id")
                    multipartFormData.append(imageData, withName: "message", fileName: "123.png", mimeType: "multipart/form-data")
                    multipartFormData.append(dateString.data(using: String.Encoding.utf8)!, withName: "time")
                    multipartFormData.append(String(describing: self.group!.groupId!).data(using: String.Encoding.utf8)!, withName: "group_id")
                    multipartFormData.append(String(Session.getInteger(forKey: Session.ID)).data(using: String.Encoding.utf8)!, withName: "u_id")
                    multipartFormData.append(Session.getString(forKey: Session.TOKEN_CODE).data(using: String.Encoding.utf8)!, withName: "token")
                },
                to: Utils.BASE_URL + "v2/reply/file",
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

                                self.getReplies()
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
            self.dismiss(animated: true, completion: nil)
            let fileName = cico.lastPathComponent

            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: date as Date)

            Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(String(describing: self.message!.messageId!).data(using: String.Encoding.utf8)!, withName: "a_id")
                        multipartFormData.append(cico, withName: "message", fileName: fileName, mimeType: "multipart/form-data")
                        multipartFormData.append(dateString.data(using: String.Encoding.utf8)!, withName: "time")
                        multipartFormData.append(String(describing: self.group!.groupId!).data(using: String.Encoding.utf8)!, withName: "group_id")
                        multipartFormData.append(String(Session.getInteger(forKey: Session.ID)).data(using: String.Encoding.utf8)!, withName: "u_id")
                        multipartFormData.append(Session.getString(forKey: Session.TOKEN_CODE).data(using: String.Encoding.utf8)!, withName: "token")

                    },
                    to: Utils.BASE_URL + "v2/reply/file",
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

                                    self.getReplies()
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

    func replyUI() {
        replyView.layer.shadowColor = UIColor.black.cgColor
        replyView.layer.shadowOpacity = 0.2
        replyView.layer.shadowRadius = 10

        sendB.layer.shadowColor = UIColor(rgb: 0x476ae8).cgColor
        sendB.layer.shadowOpacity = 0.5
        sendB.layer.shadowRadius = 3
        sendB.layer.shadowOffset = CGSize(width: 2, height: 2)

        messageL.layer.cornerRadius = 10

        replyTF.layer.cornerRadius = 10
        replyTF.layer.borderWidth = 1
        replyTF.layer.borderColor = UIColor.clear.cgColor

    }

}

