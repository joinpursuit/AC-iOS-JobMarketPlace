//
//  Job.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/2/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation
import Firebase

class Job {
    let jobId: String
    let userId: String
    let title: String
    let description: String
    let imageURL: String?
    let dateCreated: String
    let isScheduled: Bool
    let creator: String
    
    init(jobDict: [String : Any]) {
        jobId = jobDict["jobId"] as? String ?? ""
        userId = jobDict["userId"] as? String ?? ""
        title = jobDict["title"] as? String ?? ""
        description = jobDict["description"] as? String ?? ""
        imageURL = jobDict["imageURL"] as? String ?? ""
        dateCreated = jobDict["dateCreated"] as? String ?? ""
        isScheduled = jobDict["isScheduled"] as? Bool ?? false
        creator = jobDict["creator"] as? String ?? ""
    }
    
    init(snapshot: DataSnapshot) {
        jobId = snapshot.childSnapshot(forPath: "jobId").value as? String ?? ""
        userId = snapshot.childSnapshot(forPath: "userId").value as? String ?? ""
        title = snapshot.childSnapshot(forPath: "title").value as? String ?? ""
        description = snapshot.childSnapshot(forPath: "description").value as? String ?? ""
        imageURL = snapshot.childSnapshot(forPath: "imageURL").value as? String ?? ""
        dateCreated = snapshot.childSnapshot(forPath: "dateCreated").value as? String ?? ""
        isScheduled = snapshot.childSnapshot(forPath: "isScheduled").value as? Bool ?? false
        creator = snapshot.childSnapshot(forPath: "creator").value as? String ?? ""
    }
}

