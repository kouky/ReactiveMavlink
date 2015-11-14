//
//  Unidentified.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 14/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct Unidentified: ReactiveMavlinkType {
    let mavlinkMessage: mavlink_message_t
}

struct UnidentifiedCodec : MessageCodec {
    
    static func decode(message: mavlink_message_t) -> ReactiveMavlinkType {
        return Unidentified(mavlinkMessage: message)
    }
}
