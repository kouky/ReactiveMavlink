//
//  Autopilot.swift
//  ReactiveMavlink
//
//  Created by Michael Koukoullis on 14/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//


public enum Autopilot: UInt8 {
    case Generic
    case Reserved
    case Slugs
    case ArdupilotMega
    case OpenPilot
    case GenericWaypointsOnly
    case WaypointsAndSimpleNavigationOnly
    case GenericMissionFull
    case Invalid
    case PPZ
    case UAVDevBoard
    case PX4
    case SMACCMPilot
    case AutoQuad
    case Armazila
    case Aerob
    case ASLUAV
    case End
    case Unknown
}
