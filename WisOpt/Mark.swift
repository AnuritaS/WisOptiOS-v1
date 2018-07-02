//
//	Mark.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Mark: NSObject, NSCoding, Mappable {

    var id: Int?
    var subject: String?
    var slot: String?
    var subject_name: String?
    var test: [Test]?


    class func newInstance(map: Map) -> Mappable? {
        return Mark()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        id <- map["id"]
        subject <- map["subject"]
        slot <- map["slot"]
        subject_name <- map["subject_name"]
        test <- map["test"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        subject = aDecoder.decodeObject(forKey: "subject") as? String
        subject_name = aDecoder.decodeObject(forKey: "subject_name") as? String
        slot = aDecoder.decodeObject(forKey: "slot") as? String
        test = aDecoder.decodeObject(forKey: "test") as? [Test]

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if subject != nil {
            aCoder.encode(subject, forKey: "subject")
        }
        if slot != nil {
            aCoder.encode(slot, forKey: "slot")
        }
        if subject_name != nil {
            aCoder.encode(subject, forKey: "subject_name")
        }
        if test != nil {
            aCoder.encode(test, forKey: "test")
        }

    }

}
