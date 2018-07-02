// WisOpt copyright Monkwish 2017

import Foundation

class MessageItem {

    let HEADER = 0
    let MESSAGE = 1
    let REPLY = 2
    let MEMBER = 3

    var message: Announcements? = nil
    var reply: Reply? = nil
    var header: String? = nil
    var member: Member? = nil
    var type = -1

    init(header h: String) {
        self.header = h
        self.type = HEADER
    }

    init(message m: Announcements) {
        self.message = m
        self.type = MESSAGE
    }

    init(reply r: Reply) {
        self.reply = r
        self.type = REPLY
    }

    init(member mem: Member) {
        self.member = mem
        self.type = MEMBER
    }
}
