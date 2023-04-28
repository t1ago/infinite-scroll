//
//  MainModels.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 25/04/23.
//

import Foundation

enum MainModels {
    enum Fetch {
        struct Request {
            var name: String
            var nextPage: String
        }
        struct Response {
            var data: CharacterResponseModel?
        }
        struct ViewModel {
            var reloadedData: Bool
            var isLastPage: Bool
            var data: CharacterResponseModel?
        }
    }
}
