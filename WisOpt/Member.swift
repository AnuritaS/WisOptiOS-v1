//
//	Member.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Member: NSObject, NSCoding, Mappable {

    var department: String?
    var id: Int?
    var name: String?
    var profession: String?
    var regId: String?
    var status: String?
    var year: String?
    var members: [Member]?


    class func newInstance(map: Map) -> Mappable? {
        return Member()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        department <- map["department"]
        id <- map["id"]
        name <- map["name"]
        profession <- map["profession"]
        regId <- map["reg_id"]
        status <- map["status"]
        year <- map["year"]
        members <- map["Members"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        department = aDecoder.decodeObject(forKey: "department") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        profession = aDecoder.decodeObject(forKey: "profession") as? String
        regId = aDecoder.decodeObject(forKey: "reg_id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        year = aDecoder.decodeObject(forKey: "year") as? String
        members = aDecoder.decodeObject(forKey: "Members") as? [Member]

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if department != nil {
            aCoder.encode(department, forKey: "department")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if profession != nil {
            aCoder.encode(profession, forKey: "profession")
        }
        if regId != nil {
            aCoder.encode(regId, forKey: "reg_id")
        }
        if status != nil {
            aCoder.encode(status, forKey: "status")
        }
        if year != nil {
            aCoder.encode(year, forKey: "year")
        }
        if members != nil {
            aCoder.encode(members, forKey: "Members")
        }

    }

}
