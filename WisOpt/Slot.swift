//
//	Slot.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Slot: NSObject, NSCoding, Mappable {

    var batch: String?
    var classFrom: String?
    var classTo: String?
    var tDayOrder: String?
    var tSlot: String?


    class func newInstance(map: Map) -> Mappable? {
        return Slot()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        batch <- map["Batch"]
        classFrom <- map["class_from"]
        classTo <- map["class_to"]
        tDayOrder <- map["t_day_order"]
        tSlot <- map["t_slot"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        batch = aDecoder.decodeObject(forKey: "Batch") as? String
        classFrom = aDecoder.decodeObject(forKey: "class_from") as? String
        classTo = aDecoder.decodeObject(forKey: "class_to") as? String
        tDayOrder = aDecoder.decodeObject(forKey: "t_day_order") as? String
        tSlot = aDecoder.decodeObject(forKey: "t_slot") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if batch != nil {
            aCoder.encode(batch, forKey: "Batch")
        }
        if classFrom != nil {
            aCoder.encode(classFrom, forKey: "class_from")
        }
        if classTo != nil {
            aCoder.encode(classTo, forKey: "class_to")
        }
        if tDayOrder != nil {
            aCoder.encode(tDayOrder, forKey: "t_day_order")
        }
        if tSlot != nil {
            aCoder.encode(tSlot, forKey: "t_slot")
        }

    }

}
