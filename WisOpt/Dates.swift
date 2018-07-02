//
//	Date.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Dates: NSObject, NSCoding, Mappable {

    var classDate: String?
    var ispresent: String?
    var topic: String?


    class func newInstance(map: Map) -> Mappable? {
        return Dates()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        classDate <- map["class_date"]
        ispresent <- map["ispresent"]
        topic <- map["topic"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        classDate = aDecoder.decodeObject(forKey: "class_date") as? String
        ispresent = aDecoder.decodeObject(forKey: "ispresent") as? String
        topic = aDecoder.decodeObject(forKey: "topic") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if classDate != nil {
            aCoder.encode(classDate, forKey: "class_date")
        }
        if ispresent != nil {
            aCoder.encode(ispresent, forKey: "ispresent")
        }
        if topic != nil {
            aCoder.encode(topic, forKey: "topic")
        }

    }

}
