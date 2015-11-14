//
//  Heartbeat.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 13/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct Heartbeat: ReactiveMavlinkType {
    let autopilot: Autopilot
    let mavlinkMessage: mavlink_message_t
}

struct HeartbeatCodec : MessageCodec {
    
    static func decode(message: mavlink_message_t) -> ReactiveMavlinkType {
        var msg = message
        var heartbeat = mavlink_heartbeat_t()
        mavlink_msg_heartbeat_decode(&msg, &heartbeat);
        return Heartbeat(
            autopilot: Autopilot(rawValue: heartbeat.autopilot) ?? Autopilot.Unknown,
            mavlinkMessage: message
        )
    }
}
