//
//	Attendance.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class Attendance: NSObject, NSCoding, Mappable {

    var dates: [Dates]?
    var facultyName: String?
    var lastTopicCover: String?
    var percentage: Double?
    var presentHours: Int?
    var room: String?
    var serial: Int?
    var slotName: String?
    var subjectCode: String?
    var subjectName: String?
    var totalHours: Int?
    var userData: UserData?
    var attendance: [Attendance]?
    var details: Detail?
    var marks: [Mark]?
    var status: String?


    class func newInstance(map: Map) -> Mappable? {
        return Attendance()
    }

    required init?(map: Map) {
    }

    private override init() {
    }

    func mapping(map: Map) {
        dates <- map["dates"]
        facultyName <- map["faculty_name"]
        lastTopicCover <- map["last_topic_cover"]
        percentage <- map["percentage"]
        presentHours <- map["present_hours"]
        room <- map["room"]
        serial <- map["serial"]
        slotName <- map["slot_name"]
        subjectCode <- map["subject_code"]
        subjectName <- map["subject_name"]
        totalHours <- map["total_hours"]
        userData <- map["UserData"]
        attendance <- map["attendance"]
        details <- map["details"]
        marks <- map["marks"]
        status <- map["status"]

    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        dates = aDecoder.decodeObject(forKey: "dates") as? [Dates]
        facultyName = aDecoder.decodeObject(forKey: "faculty_name") as? String
        lastTopicCover = aDecoder.decodeObject(forKey: "last_topic_cover") as? String
        percentage = aDecoder.decodeObject(forKey: "percentage") as? Double
        presentHours = aDecoder.decodeObject(forKey: "present_hours") as? Int
        room = aDecoder.decodeObject(forKey: "room") as? String
        serial = aDecoder.decodeObject(forKey: "serial") as? Int
        slotName = aDecoder.decodeObject(forKey: "slot_name") as? String
        subjectCode = aDecoder.decodeObject(forKey: "subject_code") as? String
        subjectName = aDecoder.decodeObject(forKey: "subject_name") as? String
        totalHours = aDecoder.decodeObject(forKey: "total_hours") as? Int
        userData = aDecoder.decodeObject(forKey: "UserData") as? UserData
        attendance = aDecoder.decodeObject(forKey: "attendance") as? [Attendance]
        details = aDecoder.decodeObject(forKey: "details") as? Detail
        marks = aDecoder.decodeObject(forKey: "marks") as? [Mark]
        status = aDecoder.decodeObject(forKey: "status") as? String

    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if dates != nil {
            aCoder.encode(dates, forKey: "dates")
        }
        if facultyName != nil {
            aCoder.encode(facultyName, forKey: "faculty_name")
        }
        if lastTopicCover != nil {
            aCoder.encode(lastTopicCover, forKey: "last_topic_cover")
        }
        if percentage != nil {
            aCoder.encode(percentage, forKey: "percentage")
        }
        if presentHours != nil {
            aCoder.encode(presentHours, forKey: "present_hours")
        }
        if room != nil {
            aCoder.encode(room, forKey: "room")
        }
        if serial != nil {
            aCoder.encode(serial, forKey: "serial")
        }
        if slotName != nil {
            aCoder.encode(slotName, forKey: "slot_name")
        }
        if subjectCode != nil {
            aCoder.encode(subjectCode, forKey: "subject_code")
        }
        if subjectName != nil {
            aCoder.encode(subjectName, forKey: "subject_name")
        }
        if totalHours != nil {
            aCoder.encode(totalHours, forKey: "total_hours")
        }
        if userData != nil {
            aCoder.encode(userData, forKey: "UserData")
        }
        if attendance != nil {
            aCoder.encode(attendance, forKey: "attendance")
        }
        if details != nil {
            aCoder.encode(details, forKey: "details")
        }
        if marks != nil {
            aCoder.encode(marks, forKey: "marks")
        }
        if status != nil {
            aCoder.encode(status, forKey: "status")
        }

    }

}
