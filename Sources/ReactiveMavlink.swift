//
//  ReactiveMavlink.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 13/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink
import ReactiveCocoa

public class ReactiveMavlink {
    
    // MARK: Public signals
    let heartbeat: Signal<Heartbeat, NSError>
    let message: Signal<ReactiveMavlinkType, NSError>
    
    private let mavlinkMessage: Signal<mavlink_message_t, NSError>
    private let mavlinkMessageObserver: Observer<mavlink_message_t, NSError>

    init() {
        (mavlinkMessage, mavlinkMessageObserver) = Signal<mavlink_message_t, NSError>.pipe()

        message = mavlinkMessage.map { m in
            switch m.msgid {
            case 0: return HeartbeatCodec.decode(m)
            default: return UnidentifiedCodec.decode(m)
            }
        }
        
        heartbeat = message.filter { !($0 is Heartbeat) }.map { $0 as! Heartbeat }
    }
    
    func receiveData(data: NSData) {
        var bytes = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes, length: data.length)
        
        for byte in bytes {
            var message = mavlink_message_t()
            var status = mavlink_status_t()
            let channel = UInt8(MAVLINK_COMM_1.rawValue)
            if mavlink_parse_char(channel, byte, &message, &status) != 0 {
                mavlinkMessageObserver.sendNext(message)
            }
        }
    }
}

protocol MessageCodec {
    static func decode(var message: mavlink_message_t) -> ReactiveMavlinkType
}

protocol ReactiveMavlinkType {
    var mavlinkMessageId: UInt8 { get }
}
