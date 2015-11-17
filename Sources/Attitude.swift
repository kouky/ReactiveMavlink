//
//  Attitude.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 15/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink

public struct Attitude: MessageType {
    public let id: UInt8
    public let roll: Float
    public let pitch: Float
    public let yaw: Float
    public let rollSpeed: Float
    public let pitchSpeed: Float
    public let yawSpeed: Float
}

struct AttitudeDecoder : MessageDecoder {
    
    static func decode(message: mavlink_message_t) -> MessageType {
        var msg = message
        var attitude = mavlink_attitude_t()
        mavlink_msg_attitude_decode(&msg, &attitude);
        return Attitude(
            id: message.msgid,
            roll: attitude.roll,
            pitch: attitude.pitch,
            yaw: attitude.yaw,
            rollSpeed: attitude.rollspeed,
            pitchSpeed: attitude.pitchspeed,
            yawSpeed: attitude.yawspeed
        )
    }
}
