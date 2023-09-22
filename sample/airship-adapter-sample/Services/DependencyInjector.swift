//
//  DependencyInjector.swift
//  airship-adapter-sample
//
//  Created by Andrew Tran on 6/9/22.
//

import Foundation

class DependencyInjector {
    private static var instance: DependencyInjector?
    private let defaultsService: DefaultsService
    private let gimbalService: GimbalService
    
    static func getInstance() -> DependencyInjector {
        if let instance = instance {
            return instance
        } else {
            let newInstance: DependencyInjector = DependencyInjector()
            instance = newInstance
            
            return newInstance
        }
    }
    
    init() {
        self.defaultsService = DefaultsService()
        self.gimbalService = GimbalService()
    }
    
    func getDefaultsService() -> DefaultsService {
        return self.defaultsService
    }
    
    func getGimbalService() -> GimbalService {
        return self.gimbalService
    }
}
