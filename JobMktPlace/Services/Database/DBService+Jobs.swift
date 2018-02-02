//
//  DBService+Jobs.swift
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
        childByAutoId.setValue(["title"         : title,
                                "description"   : description,
                                "authUserId"    : AuthUserService.getCurrentUser()?.uid,
                                "creator"       : AuthUserService.getCurrentUser()?.displayName,
                                "jobId"         : childByAutoId.key]) { (error, dbRef) in
                                    if let error = error {
                                        print("addJob error: \(error)")
                                    } else {
                                        print("job added @ database reference: \(dbRef)")
                                        
                                        // add an image to storage
                                        StorageService.manager.storeImage(image: image, jobId: childByAutoId.key)
                                        
                                        // TODO: add image to database
                                    }
        }
    }
}
