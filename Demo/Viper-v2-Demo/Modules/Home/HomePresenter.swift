//
//  HomePresenter.swift
//  Viper-v2-Demo
//
//  Created by Donik Vrsnak on 4/11/18.
//  Copyright (c) 2018 Infinum. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Alamofire

final class HomePresenter {

    // MARK: - Private properties -

    private unowned var _view: HomeViewInterface
    private var _interactor: HomeInteractorInterface
    private var _wireframe: HomeWireframeInterface
    
    private let _authorizationManager = AuthorizationAdapter.shared
    
    private var _items: [Pokemon] = [] {
        didSet {
            _view.reloadData()
        }
    }

    // MARK: - Lifecycle -

    init(wireframe: HomeWireframeInterface, view: HomeViewInterface, interactor: HomeInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
}

// MARK: - Extensions -

extension HomePresenter: HomePresenterInterface {
    func viewDidLoad() {
        
        self._view.setLoadingVisible(true)
        _interactor.getPokemons { [weak self] (response) -> (Void) in
            self?._view.setLoadingVisible(false)
            self?._handlePokemonListResult(response.result)
        }
    }
    
    func didSelectLogoutAction() {
        _authorizationManager.authorizationHeader = nil
        _wireframe.navigate(to: .login)
    }
    
    func didSelectAddAction() {
        _wireframe.navigate(to: .add)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOrItems(in section: Int) -> Int {
        return _items.count
    }
    
    func item(at indexPath: IndexPath) -> HomeViewItemInterface {
        return _items[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let pokemon = _items[indexPath.row]
        _wireframe.navigate(to: .details(pokemon))
    }
    
    // MARK: Utility
    
    private func _handlePokemonListResult(_ result: Result<[Pokemon]>) {
        switch result {
        case .success(let jsonObject):
            _items = jsonObject
            _view.setEmptyPlaceholderHidden(_items.count > 0)
        case .failure(let error):
            _wireframe.showErrorAlert(with: error.message)
        }
    }
}
