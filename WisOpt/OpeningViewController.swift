//
//  OpeningViewController.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 31/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class OpeningViewController: OpeningView {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupView()
        loginB.addTarget(self, action: #selector(openLoginVC(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    @objc func openLoginVC(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLoginVC", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
