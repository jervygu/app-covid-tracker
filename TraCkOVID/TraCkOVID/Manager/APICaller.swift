//
//  APICaller.swift
//  TraCkOVID
//
//  Created by Jervy Umandap on 6/29/21.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    enum DataScope {
        case national
        case state(State)
    }
    
    public func getCovidData(for scope: DataScope, completion: @escaping(Result<String, Error>) -> Void) {
        
    }
        
    public func getStateList(completion: @escaping(Result<[State], Error>) -> Void) {
        
    }
    
    
        
        
}


// MARK: - MODELS

struct State: Codable  {
    
}
