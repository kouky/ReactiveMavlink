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
    public let attitude: Signal<Attitude, NSError>
    public let unidentified: Signal<Unidentified, NSError>
    
    // MARK: Private properties
    let adapter = ReactiveMavlinkAdapter()

    // MARK: Public methods
    public init() {
        heartbeat = adapter.message.extract()
        attitude = adapter.message.extract()
        unidentified = adapter.message.extract()
    }
    
    public func receiveData(data: NSData) {
        adapter.processData(data)
    }
    
    deinit {
        adapter.dispose()
    }
}

class ReactiveMavlinkAdapter {
    
    let message: Signal<MessageType, NSError>
    private let mavlink: Signal<mavlink_message_t, NSError>
    private let mavlinkObserver: Observer<mavlink_message_t, NSError>

    init() {
        (mavlink, mavlinkObserver) = Signal<mavlink_message_t, NSError>.pipe()
        
        message = mavlink.map { msg in
            switch msg.msgid {
            case 0: return HeartbeatCodec.decode(msg)
            case 30: return AttitudeCodec.decode(msg)
            default: return UnidentifiedCodec.decode(msg)
            }
        }
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
    
    func dispose() {
        mavlinkObserver.sendCompleted()
    }
}

extension Signal {
    func extract<T>() -> Signal<T, Error> {
        return self.filter { $0 is T }.map { $0 as! T }
    }
}
