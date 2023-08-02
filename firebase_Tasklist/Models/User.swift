//
//  User.swift
//  firebase_Tasklist
//
//  Created by Igor on 02.08.2023.
//

import Foundation
import FirebaseAuth


struct User {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
