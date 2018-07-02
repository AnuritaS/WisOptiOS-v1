///
//  PaymentViewController.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 29/03/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import Razorpay
import NVActivityIndicatorView

class PaymentViewController: UIViewController, RazorpayPaymentCompletionProtocol {
    func onPaymentError(_ code: Int32, description str: String) {
        print("ERROR in pay")
    }

    func onPaymentSuccess(_ payment_id: String) {
        print("Success in pay")
    }


    var razorpay: Razorpay!

    override func viewDidLoad() {
        super.viewDidLoad()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        razorpay = Razorpay.initWithKey("rzp_test_AFS1YxzlSZ3k8D", andDelegate: self)
        showPaymentForm()

    }

    internal func showPaymentForm() {
        let options: [String: Any] = [
            "amount": "100",
            "description": "purchase description",
            "image": "https://url-to-image.png",
            "name": "WisPay",
            "prefill": [
                "contact": "9176442606",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#476ae8"
            ]
        ]
        razorpay.open(options)
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

