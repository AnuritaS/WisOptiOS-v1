//
//  LoginView.swift
//  WisOpt
//
//  Created by WisOpt MacBook on 06/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

protocol LoginView {
    func onNextLogin()

    func onCompleteLogin()

    func onErrorLogin()

    func checkIsLogin()

    func setIsLogin()

    func present(alert: UIAlertController)

    func showAlert(title: String, message: String)
}
