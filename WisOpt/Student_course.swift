//
//	Student_course.swift
//  Created by Anurita Srivastava on 06/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.

import Foundation
import ObjectMapper


class Student_course: NSObject, NSCoding, Mappable {

    var course: [Course]?
    var slots: [Slot]?
    var status: String?


    class func newInstance(map: Map) -> Mappable? {
        return Student_course()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        course <- map["course"]
        slots <- map["slots"]
        status <- map["status"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        course = aDecoder.decodeObject(forKey: "course") as? [Course]
        slots = aDecoder.decodeObject(forKey: "slots") as? [Slot]
        status = aDecoder.decodeObject(forKey: "status") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if course != nil {
            aCoder.encode(course, forKey: "course")
        }
        if slots != nil {
            aCoder.encode(slots, forKey: "slots")
        }
        if status != nil {
            aCoder.encode(status, forKey: "status")
        }

    }

}
