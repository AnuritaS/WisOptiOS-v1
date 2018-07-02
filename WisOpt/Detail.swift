//
//	Detail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Detail: NSObject, NSCoding, Mappable {

    var registrationNumber: String?
    var classInchargeId: String?
    var classInchargeName: String?
    var studentEmail: String?
    var yearCoordinatorId: String?
    var yearCoordinatorName: String?


    class func newInstance(map: Map) -> Mappable? {
        return Detail()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        registrationNumber <- map["Registration_Number"]
        classInchargeId <- map["classInchargeId"]
        classInchargeName <- map["classInchargeName"]
        studentEmail <- map["studentEmail"]
        yearCoordinatorId <- map["yearCoordinatorId"]
        yearCoordinatorName <- map["yearCoordinatorName"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        registrationNumber = aDecoder.decodeObject(forKey: "Registration_Number") as? String
        classInchargeId = aDecoder.decodeObject(forKey: "classInchargeId") as? String
        classInchargeName = aDecoder.decodeObject(forKey: "classInchargeName") as? String
        studentEmail = aDecoder.decodeObject(forKey: "studentEmail") as? String
        yearCoordinatorId = aDecoder.decodeObject(forKey: "yearCoordinatorId") as? String
        yearCoordinatorName = aDecoder.decodeObject(forKey: "yearCoordinatorName") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if registrationNumber != nil {
            aCoder.encode(registrationNumber, forKey: "Registration_Number")
        }
        if classInchargeId != nil {
            aCoder.encode(classInchargeId, forKey: "classInchargeId")
        }
        if classInchargeName != nil {
            aCoder.encode(classInchargeName, forKey: "classInchargeName")
        }
        if studentEmail != nil {
            aCoder.encode(studentEmail, forKey: "studentEmail")
        }
        if yearCoordinatorId != nil {
            aCoder.encode(yearCoordinatorId, forKey: "yearCoordinatorId")
        }
        if yearCoordinatorName != nil {
            aCoder.encode(yearCoordinatorName, forKey: "yearCoordinatorName")
        }

    }

}
