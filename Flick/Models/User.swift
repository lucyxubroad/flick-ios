//
//  User.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import FBSDKLoginKit

struct User: Codable {
    var username: String
    var firstName: String
    var lastName: String
    var profilePic: String?
    var bio: String?
    var phoneNumber: String?
    var socialIdToken: String? = AccessToken.current?.tokenString
    var socialIdTokenType: String = "facebook"
}
