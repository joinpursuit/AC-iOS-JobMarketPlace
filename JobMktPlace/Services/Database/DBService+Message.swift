//
//  DBService+Message.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

extension DBService {
    public func sendMessage(messageTitle: String, messageBody: String, recipientId: String, jobId: String) {
        guard let senderId = AuthUserService.getCurrentUser()?.uid else { fatalError("userId is nil") }
        let dateCreated = ISO8601DateFormatter().string(from: Date())
        let messageId = DBService.manager.getMessages().childByAutoId()
        let params: [String: Any] = ["messageId"    : messageId.key,
                                     "dateCreated"  : dateCreated,
                                     "senderId"     : senderId,
                                     "recipientId"  : recipientId,
                                     "jobId"        : jobId,
                                     "messageTitle" : messageTitle,
                                     "messageBody"  : messageBody]
        messageId.setValue(params) { (error, dbRef) in
            if let error = error {
                print("message send error: \(error)")
            } else {
                print("message was sent dbRef: \(dbRef)")
            }
        }
    }
}
