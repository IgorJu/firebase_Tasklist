//
//  Task.swift
//  firebase_Tasklist
//
//  Created by Igor on 02.08.2023.
//

import Foundation
import FirebaseDatabase

struct Task {
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: AnyObject]
        title = snapShotValue["title"] as! String
        userId = snapShotValue["userId"] as! String
        completed = snapShotValue["completed"] as! Bool
        ref = snapShot.ref
    }
}
