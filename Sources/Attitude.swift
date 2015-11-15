//
//  Attitude.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 15/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct Attitude: Message {
    public let roll: Float
    public let pitch: Float
    public let yaw: Float
    public let rollSpeed: Float
    public let pitchSpeed: Float
    public let yawSpeed: Float
    public let mavlinkMessageId: UInt8
}

struct AttitudeCodec : MessageCodec {
    
    static func decode(message: mavlink_message_t) -> Message {
        var msg = message
        var attitude = mavlink_attitude_t()
        mavlink_msg_attitude_decode(&msg, &attitude);
        return Attitude(
            roll: attitude.roll,
            pitch: attitude.pitch,
            yaw: attitude.yaw,
            rollSpeed: attitude.rollspeed,
            pitchSpeed: attitude.pitchspeed,
            yawSpeed: attitude.yawspeed,
            mavlinkMessageId: message.msgid
        )
    }
}
