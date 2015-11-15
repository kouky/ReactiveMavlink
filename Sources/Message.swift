//
//  Message.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 15/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public protocol Message {
    // Mavlink message id
    var id: UInt8 { get }
}

protocol MessageCodec {
    static func decode(var message: mavlink_message_t) -> Message
}


