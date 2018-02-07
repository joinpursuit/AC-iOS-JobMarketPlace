//
//  Message.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

class Message {
    let dateCreated: String
    let jobId: String
    let recipientId: String
    let senderId: String
    let messageTitle: String
    let messageBody: String
    
    init(messageDict: [String: Any]) {
        dateCreated = messageDict["dateCreated"] as? String ?? ""
        jobId = messageDict["jobId"] as? String ?? ""
        recipientId = messageDict["recipientId"] as? String ?? ""
        senderId = messageDict["senderId"] as? String ?? ""
        messageTitle = messageDict["messageTitle"] as? String ?? ""
        messageBody = messageDict["messageBody"] as? String ?? ""
    }
}
