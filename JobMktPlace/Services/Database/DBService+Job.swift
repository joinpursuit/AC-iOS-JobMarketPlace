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
}
