// WisOpt copyright Monkwish 2017

import Foundation
import ObjectMapper

class User: Mappable {
    var id: Int?
    var name: String?
    var regId: String?
    var gender: String?
    var email: String?
    var university: String?
    var profession: String?
    var token_code: String?
    var first_time_login: Bool?
    var signed_in: Bool?
    var department: String?
    var year: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        regId <- map["reg_id"]
        gender <- map["gender"]
        email <- map["email"]
        university <- map["university"]
        profession <- map["profession"]
        token_code <- map["token_code"]
        first_time_login <- map["first_time_login"]
        signed_in <- map["signed_in"]
        department <- map["department"]
        year <- map["year"]
    }
}


