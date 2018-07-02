// WisOpt copyright Monkwish 2017

import UIKit

class AboutUsViewController: UIViewController {
    


    var myView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName:"logo")

        return view
    }()
    var About: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "WisOpt is a communication channel between students and teachers providing a single point medium to share information. Sharing information between teachers and students is happening in unorganized and informal ways, with WisOpt we are proposing a more formal and professional medium to communicate with well organized and optimised data."
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        view.textAlignment = .center
        view.textColor = UIColor(rgb: 0x9c9c9c)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping

        return view
    }()


    var privacy_pol: UIButton = {
        var view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x476ae8)
        view.setTitle("Privacy Policy", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor

        return view
    }()

    var joinUs: UIButton = {
        var view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xffffff)
        view.setTitle("Join Us", for: .normal)
        view.setTitleColor(UIColor(rgb: 0x476ae8), for: .normal)
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(rgb: 0x476ae8).cgColor

        return view
    }()

    var company: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "© 2017 MONKWISH. ALL RIGHTS RESERVED."
        view.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        view.textAlignment = .center
        view.textColor = UIColor(rgb: 0x494949)

        return view
    }()

    var webView: UIWebView = {
        var view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(rgb: 0xffffff)
        // Do any additional setup after loading the view.
        privacy_pol.addTarget(self, action: #selector(visitPrivacy(_:)), for: .touchUpInside)
        joinUs.addTarget(self, action: #selector(joinTeam(_:)), for: .touchUpInside)
        setupView()
    }

    func setupView() {

        view.addSubview(myView)
        myView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 40).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        myView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        view.addSubview(About)
        About.topAnchor.constraint(equalTo: myView.bottomAnchor, constant: 20).isActive = true
        About.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        About.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        About.sizeToFit()


        view.addSubview(privacy_pol)
        privacy_pol.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privacy_pol.topAnchor.constraint(equalTo: About.bottomAnchor, constant: 20).isActive = true
        privacy_pol.heightAnchor.constraint(equalToConstant: 50).isActive = true
        privacy_pol.widthAnchor.constraint(equalToConstant: 216).isActive = true

        view.addSubview(joinUs)
        joinUs.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        joinUs.topAnchor.constraint(equalTo: privacy_pol.bottomAnchor, constant: 20).isActive = true
        joinUs.heightAnchor.constraint(equalToConstant: 50).isActive = true
        joinUs.widthAnchor.constraint(equalToConstant: 216).isActive = true

        view.addSubview(company)
        company.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -20).isActive = true
        company.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        company.sizeToFit()

    }

    @objc func visitPrivacy(_ sender: UIButton) {

        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        webView.loadRequest(URLRequest(url: URL(string: "https://wisopt.com/legal")!))
    }

    @objc func joinTeam(_ sender: UIButton) {

        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        webView.loadRequest(URLRequest(url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSejN2WQo-xXqPqgqudk74k_3TkKXv1jCSS-cj6NMO3Rqb-8Mg/viewform?usp=sf_link#response=ACYDBNgTQbTDNS4hh4nzKM5JpGR469F_rwuZzuo8f8hzNxZt768Q7PCGjGDiGFg")!))
    }
}

