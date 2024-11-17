//
//  AuthModel.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/16.
//

import Foundation

struct Auth: Codable, Equatable {
    let token: String // The value of the access token.
    let addr: String // The IP address to which the token was issued. Can only be used from this address.
    let agent: String // The User-Agent value which must be used with this token.
}
