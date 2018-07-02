// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class GetEventList: Mappable {

    var examList: [Event]?
    var colorList: [Color]?
    var feedbackList: [Feedback]?
    var academicList: [DayOrder]?
    var events: [EventFeed]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        examList <- map["list"]
        colorList <- map["color"]
        feedbackList <- map["feedback"]
        academicList <- map["acadamicList"]
        events <- map["events"]
    }
}

class Event: Mappable {

    var eId: Int?
    var eSubjectName: String?
    var eSubjectCode: String?
    var eRegisterId: String?
    var eSemester: String?
    var eDepartment: String?
    var eDate: String?
    var eSession: String?
    var eStart: String?
    var eEnd: String?
    var eBlock: String?
    var eRoom: String?

    required init?(map: Map) {
        eId <- map["e_id"]
        eSubjectName <- map["e_sub_name"]
        eSubjectCode <- map["e_sub_code"]
        eRegisterId <- map["e_reg_id"]
        eSemester <- map["e_sem"]
        eDepartment <- map["e_department"]
        eDate <- map["e_date"]
        eSession <- map["e_session"]
        eStart <- map["e_start"]
        eEnd <- map["e_end"]
        eBlock <- map["e_block"]
        eRoom <- map["e_room"]
    }

    func mapping(map: Map) {

    }
}

class Color: Mappable {

    var color: String?
    var subjectCode: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        color <- map["color"]
        subjectCode <- map["code"]
    }
}

class Feedback: Mappable {

    var eId: Int?
    var eFeedback: String?
    var eTime: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        eId <- map["e_id"]
        eFeedback <- map["e_feedback"]
        eTime <- map["e_time"]
    }
}

class DayOrder: Mappable {

    var oId: Int?
    var oDate: String?
    var day: String?
    var dayOrder: String?
    var event: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        oId <- map["o_id"]
        oDate <- map["o_Date"]
        day <- map["Day"]
        dayOrder <- map["Day_Order"]
        event <- map["Event"]
    }
}

class EventFeed: Mappable {

    var eventId: Int?
    var eventTitle: String?
    var eventDate: String?
    var eventTime: String?
    var eventVenue: String?
    var eventLink: String?
    var eventFee: String?
    var eventOD: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        eventId <- map["event_id"]
        eventTitle <- map["event_title"]
        eventDate <- map["event_date"]
        eventTime <- map["event_time"]
        eventVenue <- map["event_venue"]
        eventLink <- map["event_link"]
        eventFee <- map["event_fee"]
        eventOD <- map["event_od"]
    }
}

