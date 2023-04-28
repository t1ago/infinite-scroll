//
//  LoadingView.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 25/04/23.
//

import UIKit
import Foundation



class LoadingView: UIView {
    enum LoadingViewSize {
        case small
        case medium
        case big
    }
    
    private let TIME_ANIMATION = 0.5
    private var SIZE_LOADINGVIEW_CONSTRAINT: (width: CGFloat, height: CGFloat) = (300.0, 200.0)
    private let NAME_LOADINGVIEW = "loading"
    
    static let shared = LoadingView()
    
    var parentView: UIView? = nil
    var isAnimation: Bool = false
    
    lazy var loadingView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: NAME_LOADINGVIEW))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in parentView: UIView, size: LoadingViewSize = .big) {
        switch size {
        case .big:
            SIZE_LOADINGVIEW_CONSTRAINT = (300.0, 200.0)
        case .medium:
            SIZE_LOADINGVIEW_CONSTRAINT = (150.0, 100.0)
        case .small:
            SIZE_LOADINGVIEW_CONSTRAINT = (30.0, 20.0)
        }
        
        configureLayout()
        
        self.parentView = parentView
        guard let view = self.parentView else { return }
        isAnimation = true
        animateLoading()
        
        UIView.transition(with: view,
                          duration: TIME_ANIMATION,
                          options: .transitionCrossDissolve) {
            view.addSubview(self)
        }
    }
    
    func hide() {
        isAnimation = false
        animateLoading()
        
        if let parentView = parentView {
            UIView.transition(with: parentView,
                              duration: TIME_ANIMATION,
                              options: .transitionCrossDissolve) {
                self.removeFromSuperview()
                self.parentView = nil
            }
        }
    }
    
    private func configureLayout() {
        self.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalToConstant: SIZE_LOADINGVIEW_CONSTRAINT.width),
            loadingView.widthAnchor.constraint(equalToConstant: SIZE_LOADINGVIEW_CONSTRAINT.height),
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func animateLoading() {
        if !isAnimation { return }
        
        UIView.animate(withDuration: 4.0,
                       delay: 0.0,
                       options: .curveLinear) {
            self.loadingView.transform = self.loadingView.transform.rotated(by: .pi)
        } completion: { _ in
            self.animateLoading()
        }
    }
}
