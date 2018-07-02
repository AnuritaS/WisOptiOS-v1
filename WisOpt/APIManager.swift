//
//  APIManager.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 06/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.
//

import UIKit
import Alamofire

protocol APIManagerDelegate: class {
    func reloadCalendarView(_ cData: [Student_course])
}

class APIManager: NSObject {
    weak var delegate: APIManagerDelegate?

    func getCourses() {
        let u_id = Session.getInteger(forKey: Session.ID)

        let tc = Session.getString(forKey: Session.TOKEN_CODE)

        let param: [String: String] = ["userId": "\(u_id)", "token": "\(tc)"]
        Alamofire.request(Utils.BASE_URL + "v2/calendar/course", method: .post, parameters: param).responseJSON { response in
            switch response.result {
            case .success:

                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let cal = Student_course(JSONString: utf8Text)
                    //let code = cal?.status

                    // if code == true{
                    print("Got client data successfully")
                    self.delegate?.reloadCalendarView([cal!])

                    /* }else{
                     print("Unable to search")
                     }*/
                }
            case .failure:
                print("Error Ocurred in getting calendar data!")
            }
        }
    }
}

