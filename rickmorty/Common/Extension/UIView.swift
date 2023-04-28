//
//  UIView.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 27/04/23.
//

import UIKit

extension UIView {
    public func applyCornerRadius(radius: CGFloat = 10.0) {
        self.clipsToBounds = (radius >= 0.0)
        self.layer.masksToBounds = (radius >= 0.0)
        self.layer.cornerRadius = radius
    }
}
