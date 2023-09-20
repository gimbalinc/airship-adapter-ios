//
//  GimbalService.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 5/18/22.
//

import Foundation
import Gimbal

class GimbalService: NSObject {
    private var defaultsService: DefaultsService
    private var placeManager: PlaceManager
    
    override init() {
        self.defaultsService = DefaultsService.shared()
        self.placeManager = PlaceManager()
        
        super.init()
        
        self.placeManager.delegate = self
    }
    var appId: String {
        return Gimbal.applicationInstanceIdentifier() ?? "--"
    }
    
    var isGimbalStarted: Bool {
        return Gimbal.isStarted()
    }
    
    var establishedLocations: [EstablishedLocation] {
        return EstablishedLocationManager.establishedLocations()
    }
    
    func startGimbal() {
        Gimbal.start()
    }
    
    func stopGimbal() {
        Gimbal.stop()
    }
    
    func resetAppId() {
        Gimbal.resetApplicationInstanceIdentifier()
    }
}

extension GimbalService: PlaceManagerDelegate {
    func placeManager(_ manager: PlaceManager, didBegin visit: Visit) {
        print("Did Enter Place: \(visit.place)")
        self.notifyAndSavePlaceEventWith(
            firstDescriptor: "Enter - \(visit.place.name)",
            secondDescriptor: Date().toFormattedLocalString()
        )
    }
    
    func placeManager(_ manager: PlaceManager, didBegin visit: Visit, withDelay delayTime: TimeInterval) {
        if (delayTime > 6) {
            self.notifyAndSavePlaceEventWith(
                firstDescriptor: "Delay - \(visit.place.name)",
                secondDescriptor: Date().toFormattedLocalString()
            )
        }
    }
    
    func placeManager(_ manager: PlaceManager, didEnd visit: Visit) {
        print("Did Exit Place: \(visit.place)")
        self.notifyAndSavePlaceEventWith(
            firstDescriptor: "Exit - \(visit.place.name)",
            secondDescriptor: Date().toFormattedLocalString()
        )
    }
    
    func placeManager(_ manager: PlaceManager, didReceive sighting: BeaconSighting, forVisits visits: [Any]) {
        print("Beacon Sighting: \(sighting), For Visits: \(visits)")
    }
    
    private func notifyAndSavePlaceEventWith(firstDescriptor: String, secondDescriptor: String) {
        let newEvent = AdapterEvent(firstDescriptor: firstDescriptor, secondDescriptor: secondDescriptor)
        self.defaultsService.save(event: newEvent)
        
        NotificationCenter.default.post(name: .didReceiveNewGimbalEvent, object: nil)
    }
}
