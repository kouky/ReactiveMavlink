//
//  Unidentified.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 14/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct Unidentified: MessageType {
    public let id: UInt8
}

struct UnidentifiedDecoder : MessageDecoder {
    
    static func decode(message: mavlink_message_t) -> MessageType {
        return Unidentified(id: message.msgid)
    }
}
