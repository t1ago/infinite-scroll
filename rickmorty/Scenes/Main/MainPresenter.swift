//
//  MainPresenter.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 25/04/23.
//

import Foundation

protocol MainPresenterLogic: AnyObject {
    func fetch(reloadedData: Bool, response: MainModels.Fetch.Response) async
    func fetch(reloadedData: Bool, response: MainModels.Fetch.Response)
}

class MainPresenter: MainPresenterLogic {
    weak var viewController: MainViewControllerLogic?
    
    func fetch(reloadedData: Bool, response: MainModels.Fetch.Response) async {
        let viewModel = makeViewModel(reloadedData: reloadedData, response: response)
        await viewController?.fetch(viewModel: viewModel)
    }
    
    func fetch(reloadedData: Bool, response: MainModels.Fetch.Response) {
        let viewModel = makeViewModel(reloadedData: reloadedData, response: response)
        viewController?.fetch(viewModel: viewModel)
    }
    
    private func makeViewModel(reloadedData: Bool, response: MainModels.Fetch.Response) -> MainModels.Fetch.ViewModel {
        var isLastPage = false
        if let info = response.data?.info {
            isLastPage = info.next == nil
        }
        
        return MainModels.Fetch.ViewModel(reloadedData: reloadedData,
                                          isLastPage: isLastPage,
                                          data: response.data)
    }
}
