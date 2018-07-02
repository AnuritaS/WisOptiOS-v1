//
//	Test.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Test: NSObject, NSCoding, Mappable {

    var score: String?
    var totalMarks: String?
    var type: String?


    class func newInstance(map: Map) -> Mappable? {
        return Test()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        score <- map["score"]
        totalMarks <- map["total_marks"]
        type <- map["type"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        score = aDecoder.decodeObject(forKey: "score") as? String
        totalMarks = aDecoder.decodeObject(forKey: "total_marks") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if score != nil {
            aCoder.encode(score, forKey: "score")
        }
        if totalMarks != nil {
            aCoder.encode(totalMarks, forKey: "total_marks")
        }
        if type != nil {
            aCoder.encode(type, forKey: "type")
        }

    }

}
