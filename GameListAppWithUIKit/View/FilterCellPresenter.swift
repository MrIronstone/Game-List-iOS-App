//
//  FilterCellPresenter.swift
//  GameListAppWithUIKit
//
//  Created by Demirtas, Husamettin on 24.02.2024.
//

import Foundation

protocol FilterCellPresenterInterface: AnyObject {
    func load()
}

final class FilterCellPresenter {
    private weak var view: FilterCellInterface?
    private let platform: Platform
    
    init(view: FilterCellInterface, platform: Platform) {
        self.view = view
        self.platform = platform
    }
    
    private func configureCell() {
        guard let name = platform.name else { return }
        view?.setPlatformTitle(name)
    }
    
    private func configurePlatformTitle() {
        guard let name = platform.name else { return }
        view?.setPlatformTitle(name)
    }
}

extension FilterCellPresenter: FilterCellPresenterInterface {
    func load() {
        configureCell()
    }
}
