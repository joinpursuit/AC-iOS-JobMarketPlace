//
//  DBService+User.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/4/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

extension DBService {
    public func addUser() {
        guard let userId = AuthUserService.getCurrentUser()?.uid else { fatalError("userId is nil") }
        guard let username = AuthUserService.getCurrentUser()?.displayName else { fatalError("displayName is nil") }
        guard let email = AuthUserService.getCurrentUser()?.email else { fatalError("email is nil") }
        let params: [String: Any] = ["userId"   : userId,
                                     "username" : username,
                                     "email"    : email]
        DBService.manager.getUsers().child(userId).setValue(params) { (error, dbRef) in
            if let error = error {
                print("error adding user with error: \(error)")
            } else {
                print("added user successfully @ dbRef: \(dbRef)")
            }
        }
    }
    
    public func addJobId(jobId: String, jobTitle: String, isCreator: Bool) {
        guard let userId = AuthUserService.getCurrentUser()?.uid else { fatalError("userId is nil") }
        DBService.manager.getUsers().child("\(userId)/jobIds").updateChildValues([jobId : jobTitle])
    }
}
