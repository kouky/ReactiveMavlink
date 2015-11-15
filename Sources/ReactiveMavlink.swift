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
    
    // MARK: Public properties
    public let heartbeat: Signal<Heartbeat, NSError>
    public let attitude:  Signal<Attitude, NSError>
    public let message:   Signal<Message, NSError>
    
    // MARK: Private properties
    let adapter = ReactiveMavlinkAdapter()

    // MARK: Public methods
    public init() {
        message = adapter.mavlink.map { m in
            switch m.msgid {
            case 0: return HeartbeatCodec.decode(m)
            case 30: return AttitudeCodec.decode(m)
            default: return UnidentifiedCodec.decode(m)
            }
        }
        
        heartbeat = message.filter { $0 is Heartbeat }.map { $0 as! Heartbeat }
        attitude = message.filter { $0 is Attitude }.map { $0 as! Attitude }
    }
    
    public func receiveData(data: NSData) {
        adapter.processData(data)
    }
}

class ReactiveMavlinkAdapter {
    
    let mavlink: Signal<mavlink_message_t, NSError>
    private let mavlinkObserver: Observer<mavlink_message_t, NSError>

    init() {
        (mavlink, mavlinkObserver) = Signal<mavlink_message_t, NSError>.pipe()
    }
    
    func processData(data: NSData) {
        var bytes = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&bytes, length: data.length)
        
        for byte in bytes {
            var message = mavlink_message_t()
            var status = mavlink_status_t()
            let channel = UInt8(MAVLINK_COMM_1.rawValue)
            if mavlink_parse_char(channel, byte, &message, &status) != 0 {
                mavlinkObserver.sendNext(message)
            }
        }
    }
}
