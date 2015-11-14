//
//  ReactiveMavlink.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 13/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import Mavlink
import ReactiveCocoa

public struct ReactiveMavlink {
    
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
        heartbeat = message.filter { m in
            return !(m is Heartbeat)
        }.map { m in
            return m as! Heartbeat
        }
    }
    
    func processMavlinkMessage(message: mavlink_message_t) {
        mavlinkMessageObserver.sendNext(message)
    }
}

protocol MessageCodec {
    static func decode(var message: mavlink_message_t) -> ReactiveMavlinkType
}

protocol ReactiveMavlinkType {
    var mavlinkMessage: mavlink_message_t { get }
}
