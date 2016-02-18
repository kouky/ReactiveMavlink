//
//  HeadUpDisplay.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 18/02/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct HeadUpDisplay: MessageType {
    public let id: UInt8
    public let airSpeed: Float
    public let groundSpeed: Float
    public let heading: Int16
    public let throttle: UInt16
    public let altitude: Float
    public let climbRate: Float
}

struct HeadUpDisplayDecoder : MessageDecoder {
    
    static func decode(message: mavlink_message_t) -> MessageType {
        var msg = message
        var hud = mavlink_vfr_hud_t()
        mavlink_msg_vfr_hud_decode(&msg, &hud);
        return HeadUpDisplay(
            id: message.msgid,
            airSpeed: hud.airspeed,
            groundSpeed: hud.groundspeed,
            heading: hud.heading,
            throttle: hud.throttle,
            altitude: hud.alt,
            climbRate: hud.climb
        )
    }
}
