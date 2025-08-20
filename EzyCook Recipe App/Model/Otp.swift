//
//  Otp.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import Foundation

struct OTP: Decodable {
    let email: String
    let otp: String
    let expiresAt: Date
}
