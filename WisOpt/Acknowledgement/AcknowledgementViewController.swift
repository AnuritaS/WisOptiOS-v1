//
//  AcknowledgementViewController.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 12/12/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftEventBus

class AcknowledgementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var message: Announcements?
    var group: Group?
    var isText: String?

    var readCount = Int()
    var unreadCount = Int()

    var unreadM = [MemberA]()
    var readM = [MemberA]()

    var isRead = true


    lazy var customSC: UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view

    }()

    //To show announcement message
    lazy var messageL: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xC5CAE3)
        view.textColor = UIColor(rgb: 0x494949)
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        view.textAlignment = .left
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        view.isEditable = false

        return view
    }()
    //To show announcement image
    var imageIV: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true

        return view

    }()

    var myView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xffffff)
        return view

    }()

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

    override func loadView() {
        super.loadView()

        loadHeader()

    }

    func loadHeader() {
        // Initialize
        let items = ["Read \(readCount)", "Unread \(unreadCount)"]
        customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0

        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.white
        customSC.tintColor = UIColor(rgb: 0x476ae8)
        customSC.addTarget(self, action: #selector(changeArray(_:)), for: .valueChanged)
    }

    @objc func changeArray(_ sender: UISegmentedControl) {

        //print("Changing Array to ")
        switch sender.selectedSegmentIndex {
        case 0:
            isRead = true
                //print("Read")
        case 1:
            isRead = false
                //print("Unread")
        default:
            isRead = true
                //print("Read")
        }
        self.myTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(target as AnyObject, name: "refresh") { result in
            // UI thread
            self.getMembersAck()
        }

        view.backgroundColor = UIColor(rgb: 0xe3e3e3)
        myTableView.register(CustomProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        setupView()
        getMembersAck()
        msg()

    }

    func setupView() {

        view.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true

        stackView.addSubview(messageL)
        messageL.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10).isActive = true
        messageL.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 10).isActive = true
        messageL.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -10).isActive = true
        messageL.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10).isActive = true
        messageL.sizeToFit()

        messageL.layer.cornerRadius = 10

        stackView.addSubview(imageIV)
        imageIV.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        imageIV.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        imageIV.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageIV.heightAnchor.constraint(equalToConstant: 80).isActive = true

        view.addSubview(myView)
        myView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        myView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true

        myView.addSubview(myTableView)
        myTableView.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 40).isActive = true
        myTableView.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -40).isActive = true
        myTableView.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true


    }

    func getMembersAck() {
        let gId = group!.groupId!
        let mId = message!.messageId!


        let url = URL(string: Utils.BASE_URL + "v2/ack")!
        let param: [String: String] = ["messageId": "\(mId)", "groupId": "\(gId)"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Get Acknowledge Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let ackRes = GetAckResult(JSONString: utf8Text)
                            let status = ackRes!.status!

                            if (status == "true") {
                                //print(utf8Text)

                                let readM = ackRes!.readMem!
                                let unreadM = ackRes!.unreadMem!
                                let readC = ackRes!.readC!
                                let totalC = ackRes!.totalC!

                                print(status)

                                self.readM = readM
                                self.unreadM = unreadM
                                self.readCount = readC
                                self.unreadCount = totalC - readC - 1


                                self.loadHeader()
                                self.myTableView.reloadData()
                            } else {
                                let alert = UIAlertController(title: "Status", message: status, preferredStyle: UIAlertControllerStyle.alert)

                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                                    action in
                                    if (action.style == .default) {
                                        self.getMembersAck()
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
                    case .failure:
                        print("Error Ocurred!")

                        let alert = UIAlertController(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", preferredStyle: UIAlertControllerStyle.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                            action in
                            if (action.style == .default) {
                                self.getMembersAck()
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

    //show message
    func msg() {

        if (isText == "0") {
            self.messageL.text = message?.message
        } else if isText == "image" {
            messageL.isHidden = true
            //show image
            let iUrl = message!.message!
            print(String(iUrl[iUrl.lastIndexOf("/")!...]))
            let url = URL(string: Utils.BASE_URL + "showimage\(String(iUrl[iUrl.lastIndexOf("/")!...]))")
            print("\(url!.absoluteString)")
            imageIV.kf.setImage(with: url)
        } else {
            messageL.isHidden = true
            imageIV.image = #imageLiteral(resourceName:"docs")
        }
    }
}

extension AcknowledgementViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isRead) {
            return readM.count
        } else {
            return unreadM.count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return customSC
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! CustomProfileCell
        cell.imageView?.image = #imageLiteral(resourceName:"profile_round")
        if (isRead) {
            cell.field.text = readM[indexPath.row].name!
            cell.value.text = readM[indexPath.row].regId!

        } else {
            cell.field.text = unreadM[indexPath.row].name!
            cell.value.text = unreadM[indexPath.row].regId!
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
