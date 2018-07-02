//
//	Course.swift
//  Created by Anurita Srivastava on 06/01/18.
//  Copyright © 2018 MonkWish Production. All rights reserved.

import Foundation
import ObjectMapper


class Course: NSObject, NSCoding, Mappable {

    var sBatch: String?
    var sClassroom: String?
    var sCourseCode: String?
    var sCourseTitle: String?
    var sFacultyId: String?
    var sFacultyName: String?
    var sLabSlot: String?
    var sSlot: String?


    class func newInstance(map: Map) -> Mappable? {
        return Course()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        sBatch <- map["s_batch"]
        sClassroom <- map["s_classroom"]
        sCourseCode <- map["s_course_code"]
        sCourseTitle <- map["s_course_title"]
        sFacultyId <- map["s_faculty_id"]
        sFacultyName <- map["s_faculty_name"]
        sLabSlot <- map["s_lab_slot"]
        sSlot <- map["s_slot"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        sBatch = aDecoder.decodeObject(forKey: "s_batch") as? String
        sClassroom = aDecoder.decodeObject(forKey: "s_classroom") as? String
        sCourseCode = aDecoder.decodeObject(forKey: "s_course_code") as? String
        sCourseTitle = aDecoder.decodeObject(forKey: "s_course_title") as? String
        sFacultyId = aDecoder.decodeObject(forKey: "s_faculty_id") as? String
        sFacultyName = aDecoder.decodeObject(forKey: "s_faculty_name") as? String
        sLabSlot = aDecoder.decodeObject(forKey: "s_lab_slot") as? String
        sSlot = aDecoder.decodeObject(forKey: "s_slot") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if sBatch != nil {
            aCoder.encode(sBatch, forKey: "s_batch")
        }
        if sClassroom != nil {
            aCoder.encode(sClassroom, forKey: "s_classroom")
        }
        if sCourseCode != nil {
            aCoder.encode(sCourseCode, forKey: "s_course_code")
        }
        if sCourseTitle != nil {
            aCoder.encode(sCourseTitle, forKey: "s_course_title")
        }
        if sFacultyId != nil {
            aCoder.encode(sFacultyId, forKey: "s_faculty_id")
        }
        if sFacultyName != nil {
            aCoder.encode(sFacultyName, forKey: "s_faculty_name")
        }
        if sLabSlot != nil {
            aCoder.encode(sLabSlot, forKey: "s_lab_slot")
        }
        if sSlot != nil {
            aCoder.encode(sSlot, forKey: "s_slot")
        }

    }

}

class CourseRow {
    var subject: String
    var subjectCode: String
    var faculty: String
    var room: String
    var timeFrom: String
    var timeTo: String
    var slot: String
    var batch: String

    init(s: String, c: String, f: String, r: String, tf: String, tt: String, sl: String, b: String) {
        subject = s
        subjectCode = c
        faculty = f
        room = r
        timeFrom = tf
        timeTo = tt
        slot = sl
        batch = b

    }
}
