//
//  UIImageView+ShowIcon.swift
//  Weather
//
//  Created by Кирилл Зубков on 24.03.2024.
//

import UIKit

extension UIImageView {
    
    func showIcon(name: String) {
        DispatchQueue.global().async {
            NetworkService.shared.fetchIcon(named: name) { [weak self] result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let image):
                        self?.image = image
                    case .failure(let error):
                        self?.image = nil
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
