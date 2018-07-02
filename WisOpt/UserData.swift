//
//	UserData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class UserData: NSObject, NSCoding, Mappable {

    var department: String?
    var email: String?
    var gender: String?
    var id: Int?
    var name: String?
    var password: String?
    var profession: String?
    var regId: String?
    var tokenCode: String?
    var university: String?
    var year: String?


    class func newInstance(map: Map) -> Mappable? {
        return UserData()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        department <- map["department"]
        email <- map["email"]
        gender <- map["gender"]
        id <- map["id"]
        name <- map["name"]
        password <- map["password"]
        profession <- map["profession"]
        regId <- map["reg_id"]
        tokenCode <- map["token_code"]
        university <- map["university"]
        year <- map["year"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        department = aDecoder.decodeObject(forKey: "department") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        profession = aDecoder.decodeObject(forKey: "profession") as? String
        regId = aDecoder.decodeObject(forKey: "reg_id") as? String
        tokenCode = aDecoder.decodeObject(forKey: "token_code") as? String
        university = aDecoder.decodeObject(forKey: "university") as? String
        year = aDecoder.decodeObject(forKey: "year") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if department != nil {
            aCoder.encode(department, forKey: "department")
        }
        if email != nil {
            aCoder.encode(email, forKey: "email")
        }
        if gender != nil {
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if password != nil {
            aCoder.encode(password, forKey: "password")
        }
        if profession != nil {
            aCoder.encode(profession, forKey: "profession")
        }
        if regId != nil {
            aCoder.encode(regId, forKey: "reg_id")
        }
        if tokenCode != nil {
            aCoder.encode(tokenCode, forKey: "token_code")
        }
        if university != nil {
            aCoder.encode(university, forKey: "university")
        }
        if year != nil {
            aCoder.encode(year, forKey: "year")
        }

    }

}
