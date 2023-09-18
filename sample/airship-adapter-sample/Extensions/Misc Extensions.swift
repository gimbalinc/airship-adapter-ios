//
//  Misc Extensions.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/18/22.
//

import Foundation

extension Date {
    func toFormattedLocalString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
}

extension Notification.Name {
    static let didReceiveNewGimbalEvent = Notification.Name("didReceiveNewGimbalEvent")
}
