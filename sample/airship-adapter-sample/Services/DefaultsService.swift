//
//  DefaultsService.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/18/22.
//

import Foundation

class DefaultsService {
    
    private let defaults = UserDefaults.standard
    private let eventsKey = "DEFAULTS_EVENTS_KEY"
    
    private static let sharedInstance = DefaultsService()
    
    static func shared() -> DefaultsService {
        return sharedInstance
    }
    
    private(set) var gimbalEvents: [AdapterEvent] {
        get {
            guard let cachedEvents = self.defaults.value(forKey: eventsKey) as? Data,
                  let decodedEvents = try? PropertyListDecoder().decode(Array<AdapterEvent>.self, from: cachedEvents) else {
                return []
            }
            
            return decodedEvents
        }
        
        set {
            self.defaults.setValue(try? PropertyListEncoder().encode(newValue), forKey: eventsKey)
        }
    }
    
    // Events
    func save(event: AdapterEvent) {
        var updatedEvents: [AdapterEvent] = []
        updatedEvents.append(event)
        updatedEvents.append(contentsOf: self.gimbalEvents)
        self.gimbalEvents = updatedEvents
    }
}
