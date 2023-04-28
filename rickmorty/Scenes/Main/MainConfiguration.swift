//
//  MainConfiguration.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 25/04/23.
//

import Foundation

class MainConfiguration {
    static func configure() -> MainViewController {
        let mainViewController = MainViewController()
        let mainInteractor = MainInteractor()
        let mainPresenter = MainPresenter()
        
        mainPresenter.viewController = mainViewController
        mainInteractor.presenter = mainPresenter
        mainViewController.interactor = mainInteractor
        
        return mainViewController
    }
}
