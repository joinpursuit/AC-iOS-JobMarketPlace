//
//  Job.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/2/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation

class Job {
    let title: String
    let description: String
    let imageURL: String?
    
    init(jobDict: [String : Any]) {
        title = jobDict["title"] as? String ?? ""
        description = jobDict["description"] as? String ?? ""
        imageURL = jobDict["imageURL"] as? String ?? ""
    }
}
