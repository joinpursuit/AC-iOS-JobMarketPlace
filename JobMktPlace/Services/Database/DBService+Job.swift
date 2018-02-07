//
//  DBService+Job.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation
import UIKit

extension DBService {
    public func addJob(title: String, description: String, image: UIImage) {
        let childByAutoId = DBService.manager.getJobs().childByAutoId()
        let dateCreated = ISO8601DateFormatter().string(from: Date())
        guard let userId = AuthUserService.getCurrentUser()?.uid else { fatalError("uid is nil")}
        guard let displayName = AuthUserService.getCurrentUser()?.displayName else { fatalError("displayName is nil") }
        childByAutoId.setValue(["jobId"         : childByAutoId.key,
                                "userId"        : userId,
                                "title"         : title,
                                "description"   : description,
                                "dateCreated"   : dateCreated,
                                "isScheduled"   : false,
                                "isComplete"    : false,
                                "creator"       : displayName,
                                "contractor"    : "",
                                "contractorId"  : ""]) { (error, dbRef) in
                                    if let error = error {
                                        print("addJob error: \(error)")
                                    } else {
                                        print("job added to database reference: \(dbRef)")
                                        
                                        // add an image to storage
                                        StorageService.manager.storeImage(image: image, jobId: childByAutoId.key)
                                        
                                        // TODO: add image to database
                                        
                                        // add job id to user
                                        DBService.manager.addJobId(jobId: childByAutoId.key, jobTitle: title, isCreator: true)
                                    }
        }
    }
    
    // isScheduled
    // contractorId
    // contractor
    public func updateJobSchedule(job: Job, isScheduled: Bool) {
        guard let userId = AuthUserService.getCurrentUser()?.uid else { fatalError("userId is nil") }
        guard let contractor = AuthUserService.getCurrentUser()?.displayName else { fatalError("displayName is nil") }
        var isScheduledValue = false
        var contractorId = ""
        var contractorName = ""
        if isScheduled {
            isScheduledValue = isScheduled
            contractorId = userId
            contractorName = contractor
            DBService.manager.sendMessage(messageTitle: "\(job.title)", messageBody: "@\(contractor) has been scheduled to complete your task", recipientId: job.userId, jobId: job.jobId)
        } else {
            DBService.manager.sendMessage(messageTitle: "\(job.title)", messageBody: "Sorry @\(contractor) can no longer complete your task", recipientId: job.userId, jobId: job.jobId)
        }
        DBService.manager.getJobs().child("\(job.jobId)/isScheduled").setValue(isScheduledValue) { (error, dbRef) in
            if let error = error {
                print("error updating schedule with error: \(error)")
            } else {
                print("updated schedule successfully dbRef: \(dbRef)")
            }
        }
        DBService.manager.getJobs().child("\(job.jobId)/contractorId").setValue(contractorId) { (error, dbRef) in
            if let error = error {
                print("error updating contractorId with error: \(error)")
            } else {
                print("updated contractorId successfully dbRef: \(dbRef)")
            }
        }
        DBService.manager.getJobs().child("\(job.jobId)/contractor").setValue(contractorName) { (error, dbRef) in
            if let error = error {
                print("error updating contractor name with error: \(error)")
            } else {
                print("updated contractor name successfully dbRef: \(dbRef)")
            }
        }
    }
    
    // remove from jobs
    // remove from user jobIds
    // remove image from storage
    public func markComplete(job: Job, isComplete: Bool) {
        if isComplete {
            DBService.manager.sendMessage(messageTitle: "\(job.title)", messageBody: "@\(job.creator) marked your task complete", recipientId: job.contractorId, jobId: job.jobId)
        } else {
            DBService.manager.sendMessage(messageTitle: "\(job.title)", messageBody: "@\(job.creator) marked your task incomplete", recipientId: job.contractorId, jobId: job.jobId)
        }
        DBService.manager.getJobs().child("\(job.jobId)/isComplete").setValue(isComplete) { (error, dbRef) in
            if let error = error {
                print("error marking complete with error: \(error)")
            } else {
                print("successfully marked complete dbRef: \(dbRef)")
            }
        }
    }
    
    public func removeJob(job: Job) {
        DBService.manager.getJobs().child(job.jobId).removeValue { (error, dbRef) in
            if let error = error {
                print("error removing job with error: \(error)")
            } else {
                print("job removed from dbRef: \(dbRef)")
            }
        }
    }
}
