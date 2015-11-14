//
//  Unidentified.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 14/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct Unidentified: ReactiveMavlinkType {
    let mavlinkMessageId: UInt8
}

struct UnidentifiedCodec : MessageCodec {
    
    static func decode(message: mavlink_message_t) -> ReactiveMavlinkType {
        return Unidentified(mavlinkMessageId: message.msgid)
    }
}
