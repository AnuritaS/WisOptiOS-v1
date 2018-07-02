//
//  OpeningView.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 01/04/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit

class OpeningView: UIViewController {

    var myLogo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    var loginB: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    var signUp: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    func setupView() {
        
        self.viewUI()
        
        view.addSubview(myLogo)
        NSLayoutConstraint.activate([
            myLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            myLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myLogo.widthAnchor.constraint(equalToConstant: 120),
            myLogo.heightAnchor.constraint(equalToConstant: 120)
        ])
       
        view.addSubview(signUp)
        NSLayoutConstraint.activate([
            signUp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUp.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            signUp.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            signUp.heightAnchor.constraint(equalToConstant: 50)
            ])
      
        view.addSubview(loginB)
        NSLayoutConstraint.activate([
            loginB.topAnchor.constraint(equalTo: signUp.bottomAnchor, constant: 30),
            loginB.leadingAnchor.constraint(equalTo: signUp.leadingAnchor),
            loginB.trailingAnchor.constraint(equalTo: signUp.trailingAnchor),
            loginB.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func viewUI(){
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(rgb: 0x065ea3).cgColor, UIColor(rgb: 0x2277a5).cgColor, UIColor(rgb: 0x3f91a7).cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)

        myLogo.image = #imageLiteral(resourceName:"logo")
        
        signUp.setTitle("Sign Up", for: .normal)
        signUp.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        signUp.layer.cornerRadius = 25
        signUp.layer.borderColor = UIColor(rgb: 0xFFFFFF).cgColor
        signUp.layer.borderWidth = 2
        signUp.layer.shadowOffset = CGSize(width: 0, height: 10)
        signUp.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signUp.layer.shadowOpacity = 1
        signUp.layer.shadowRadius = 20
        signUp.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        
        loginB.setTitle("Log In", for: .normal)
        loginB.setTitleColor(UIColor(rgb: 0x2672ec), for: .normal)
        loginB.backgroundColor = UIColor(rgb: 0xFFFFFF)
        loginB.layer.cornerRadius = 25
        loginB.layer.borderColor = UIColor(rgb: 0xFFFFFF).cgColor
        loginB.layer.borderWidth = 2
        loginB.layer.shadowOffset = CGSize(width: 0, height: 10)
        loginB.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        loginB.layer.shadowOpacity = 1
        loginB.layer.shadowRadius = 20
        loginB.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)

    }

}
