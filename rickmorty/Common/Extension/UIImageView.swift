//
//  UIImageView.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 26/04/23.
//

import UIKit
import Foundation

extension UIImageView {
    func load(url: String) {
        let urlRetrieve = URL(string: url)!
        
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: urlRetrieve) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
