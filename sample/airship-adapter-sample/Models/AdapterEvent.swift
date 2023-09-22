//
//  GimbalEvent.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/18/22.
//

import Foundation

struct AdapterEvent: Codable {
    let firstDescriptor: String
    let secondDescriptor: String
    init(firstDescriptor: String, secondDescriptor: String) {
        self.firstDescriptor = firstDescriptor
        self.secondDescriptor = secondDescriptor
    }
}
