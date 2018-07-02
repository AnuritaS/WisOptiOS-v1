//
// Created by WisOpt MacBook on 08/04/18.
// Copyright (c) 2018 MonkWish Production. All rights reserved.
//

import Foundation

class Session {
    static let ID = "ID"
    static let EMAIL = "EMAIL"
    static let REG_ID = "REG_ID"
    static let PROFESSION = "PROFESSION"
    static let UNIVERSITY = "UNIVERSITY"
    static let DEPARTMENT = "DEPARTMENT"
    static let YEAR = "YEAR"

    static let NAME = "NAME"
    static let GENDER = "GENDER"

    static let CI_ID = "CI_ID"
    static let CI_NAME = "CI_NAME"
    static let YC_ID = "YC_ID"
    static let YC_NAME = "YC_NAME"

    static let PASSWORD = "PASSWORD"

    static let IS_LOGIN = "IS_LOGIN"
    static let REMEMBER = "REMEMBER"

    static let TOKEN_CODE = "TOKEN_CODE"
    static let SIGNED_IN = "SIGNED_IN"
    static let FIRST_TIME_LOGIN = "FIRST_TIME_LOGIN"


    static let preferences = UserDefaults.standard

    static func set(value: Bool, forKey: String) {
        preferences.set(value, forKey: forKey)
    }

    static func set(value: String, forKey: String) {
        preferences.set(value, forKey: forKey)
    }

    static func set(value: Int, forKey: String) {
        preferences.set(value, forKey: forKey)
    }

    static func getBool(forKey: String) -> Bool {
        return preferences.bool(forKey: forKey)
    }

    static func getString(forKey: String) -> String {
        if preferences.string(forKey: forKey) != nil {
            return preferences.string(forKey: forKey)!
        }else{
            return "NA"
        }
    }

    static func getInteger(forKey: String) -> Int {
        return preferences.integer(forKey: forKey)
    }

    static func removeObject(forKey: String) {
        preferences.removeObject(forKey: forKey)
    }

}
