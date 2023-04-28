//
//  CharacterWorker.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 25/04/23.
//

import Foundation
import PromiseKit

struct LocationModel: Codable {
    var name: String
}

struct CharacterInfoModel: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}

struct CharacterModel: Codable {
    var id: Int
    var name: String
    var species: String
    var image: String?
    var location: LocationModel
}

struct CharacterResponseModel: Codable {
    var info: CharacterInfoModel
    var results: [CharacterModel]
}

protocol CharacterWorkerLogic {
    func fetch(request: MainModels.Fetch.Request) async -> MainModels.Fetch.Response
    func fetch(request: MainModels.Fetch.Request) -> Promise<MainModels.Fetch.Response>
}

class CharacterWorker: CharacterWorkerLogic {
    var API_URL: String { "https://rickandmortyapi.com/api/character/" }
    
    func fetch(request: MainModels.Fetch.Request) async -> MainModels.Fetch.Response {
        
        let url = generateURL(request: request)
        
        do {
            let task = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CharacterResponseModel.self, from: task.0)
            return MainModels.Fetch.Response(data: decoded)
        } catch {
            return MainModels.Fetch.Response()
        }
    }
    
    func fetch(request: MainModels.Fetch.Request) -> PromiseKit.Promise<MainModels.Fetch.Response> {
        return Promise { seal in
            let url = generateURL(request: request)
            
            let task = URLSession.shared.dataTask(with: url) { dataValue, urlResponse, errorValue in
                if let dataValue = dataValue {
                    do {
                        let decoded = try JSONDecoder().decode(CharacterResponseModel.self, from: dataValue)
                        seal.fulfill(MainModels.Fetch.Response(data: decoded))
                    }catch {
                        seal.fulfill(MainModels.Fetch.Response())
                    }
                } else {
                    seal.fulfill(MainModels.Fetch.Response())
                }
            }
            
            task.resume()
        }
    }
    
    private func generateURL(request: MainModels.Fetch.Request) -> URL {
        var urlGet = request.nextPage
        
        if request.nextPage.isEmpty {
            urlGet = "\(API_URL)?page=1"
            
            if !request.name.isEmpty {
                urlGet = "\(urlGet)&name=\(request.name)"
            }
        }
        
        print(urlGet)
        return URL(string: "\(urlGet)")!
    }
}
