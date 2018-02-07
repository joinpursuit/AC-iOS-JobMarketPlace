//
//  DBService.swift
//  JobMktPlace
//
//  Created by Alex Paul on 2/1/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBService {
    private init(){
        // reference to the root of the Firebase database
        dbRef = Database.database().reference()
        
        // children of root database node
        usersRef = dbRef.child("users")
        jobsRef = dbRef.child("jobs")
        imagesRef = dbRef.child("images")
        categoriesRef = dbRef.child("categories")
        messagesRef = dbRef.child("messages")

    }
    static let manager = DBService()
    
    private var dbRef: DatabaseReference!
    private var usersRef: DatabaseReference!
    private var jobsRef: DatabaseReference!
    private var imagesRef: DatabaseReference!
    private var categoriesRef: DatabaseReference!
    private var messagesRef: DatabaseReference!
    
    public func getDB()-> DatabaseReference { return dbRef }
    public func getUsers()-> DatabaseReference { return usersRef }
    public func getJobs()-> DatabaseReference { return jobsRef }
    public func getImages()-> DatabaseReference { return imagesRef }
    public func getCategories()-> DatabaseReference { return categoriesRef }
    public func getMessages()-> DatabaseReference { return messagesRef }
}
