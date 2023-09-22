//
//  EventsPresenter.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 6/9/22.
//

import Foundation

class EventsPresenter: NSObject {
    private weak var view: EventsViewController?
    private var defaultsService: DefaultsService?
    private var events: [AdapterEvent] = []
    
    var eventsCount: Int {
        get {
            return self.events.count
        }
    }
    
    convenience init(
        view: EventsViewController,
        defaultsService: DefaultsService
    ) {
        self.init()
        
        self.view = view
        self.defaultsService = defaultsService
        self.refreshEvents()
    }
    
    func handleNewEvent() {
        self.refreshEvents()
    }
    
    func getEvent(forIndex index: Int) -> AdapterEvent {
        guard index < self.eventsCount else {
            return AdapterEvent(firstDescriptor: "invalid index", secondDescriptor: "invalid index")
        }
        
        return self.events[index]
    }
    
    private func refreshEvents() {
        self.events = defaultsService?.gimbalEvents ?? []
        self.view?.refreshEventsTable()
    }
}
