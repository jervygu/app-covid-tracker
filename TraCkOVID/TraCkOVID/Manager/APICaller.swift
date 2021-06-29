//
//  APICaller.swift
//  TraCkOVID - TraC<OVID
//
//  Created by Jervy Umandap on 6/29/21.
//  covidtracking.com/data/api/version-2

import Foundation



class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    private struct Constants {
        static let allStatesUrl = URL(string: "https://api.covidtracking.com/v2/states.json")
    }
    
    enum DataScope {
        case national
        case state(State)
    }
    
    public func getCovidData(for scope: DataScope, completion: @escaping(Result<[DayData], Error>) -> Void) {
        let urlString: String
        switch scope {
        case .national:
            urlString = "https://api.covidtracking.com/v2/us/daily.json"
        case .state(let state):
            urlString = "https://api.covidtracking.com/v2/states/\(state.state_code.lowercased())/daily.json"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(CovidDataResponse.self, from: data)
                
                let models: [DayData] = result.data.compactMap {
                    guard let date = DateFormatter.dateFomatter.date(from: $0.date),
                          let value = $0.cases?.total.value else {
                        return nil
                    }
                    
                    return DayData(date: date, count: value)
                }
                completion(.success(models))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
        task.resume()
    }
        
    public func getStateList(completion: @escaping(Result<[State], Error>) -> Void) {
        guard let url = Constants.allStatesUrl else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(StateListResponse.self, from: data)
                let states = result.data
                completion(.success(states))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
        task.resume()
        
    }
        
}


// MARK: - MODELS

struct StateListResponse: Codable {
    let data: [State]
}

struct State: Codable  {
    let name: String
    let state_code: String
}

struct CovidDataResponse: Codable {
    let data: [CovidDataDay]
}

struct CovidDataDay: Codable {
    let cases: CovidCases?
    let date: String
}

struct CovidCases: Codable {
    let total: TotalCases
}

struct TotalCases: Codable {
    let value: Int?
}

struct DayData {
    let date: Date
    let count: Int
}


