//
//  MainInteractor.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 25/04/23.
//

import Foundation
import PromiseKit

protocol MainInteractorLogic: AnyObject {
    func fetch(name: String) async
    func fetch(name: String)
}

class MainInteractor: MainInteractorLogic {
    
    var presenter: MainPresenterLogic?
    
    var characterWorder: CharacterWorkerLogic
    var nextPage: String = ""
    var name: String = ""
    
    init(characterWorder: CharacterWorkerLogic = CharacterWorker()) {
        self.characterWorder = characterWorder
    }
    
    func fetch(name: String) async {
        let reloadedData = reloadedData(name: name)
        self.name = name
        self.nextPage = reloadedData ? "": nextPage
        
        if !reloadedData && nextPage.isEmpty {
            await makeResponse(reloadedData: reloadedData)
        }
        
        let request = MainModels.Fetch.Request(name: name, nextPage: nextPage)
        let response = await characterWorder.fetch(request: request)
        
        if let data = response.data {
            if let next = data.info.next {
                self.nextPage = next
            } else {
                self.nextPage = ""
            }
        }
        
        await makeResponse(reloadedData: reloadedData, response: response)
    }
    
    func fetch(name: String)  {
        let reloadedData = reloadedData(name: name)
        self.name = name
        self.nextPage = reloadedData ? "": nextPage
        
        if !reloadedData && nextPage.isEmpty {
            makeResponse(reloadedData: reloadedData)
        }
        
        let request = MainModels.Fetch.Request(name: name, nextPage: nextPage)
        _ = characterWorder.fetch(request: request).done { [weak self] response in
            if let data = response.data {
                if let next = data.info.next {
                    self?.nextPage = next
                } else {
                    self?.nextPage = ""
                }
            }
            
            self?.makeResponse(reloadedData: reloadedData, response: response)
        }
    }
    
    private func reloadedData(name: String) -> Bool {
        return !self.name.elementsEqual(name)
    }
    
    private func makeResponse(reloadedData: Bool, response: MainModels.Fetch.Response = MainModels.Fetch.Response()) async {
        await presenter?.fetch(reloadedData: reloadedData, response: response)
    }
    
    private func makeResponse(reloadedData: Bool, response: MainModels.Fetch.Response = MainModels.Fetch.Response()) {
        presenter?.fetch(reloadedData: reloadedData, response: response)
    }
}
