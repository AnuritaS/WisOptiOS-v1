//
//  eventPopUpViewController.swift
//  EventDetails
//
//  Created by Shreyash Sharma on 24/03/18.
//  Copyright © 2018 Shreyash Sharma. All rights reserved.
//

import UIKit

class eventPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!

    @IBOutlet weak var eventNameLabel: UILabel!


    @IBOutlet weak var eventImage: UIImageView!

    @IBOutlet weak var timeLabel: UILabel!


    @IBOutlet weak var eventDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 6.0

        popUpView.layer.masksToBounds = true

    }


    @IBAction func onClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func onViewPressed(_ sender: Any) {
    }


}


