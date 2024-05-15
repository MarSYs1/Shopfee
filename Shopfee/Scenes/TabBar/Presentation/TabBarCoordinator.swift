//
//  TabBarCoordinator.swift
//  Shopfee
//
//  Created by Ahmed Yamany on 03/05/2024.
//

import Combine
import Coordinator
import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    func viewDidDisAppear()
    func viewWillAppear()
    func showTabBar()
    func hideTabBar()
    func showCheckout()
}

final class TabBarCoordinator: TabBarCoordinatorProtocol {
    @Published var showHideTabBar: Bool = true
    var showTabBarPublisher: AnyPublisher<Bool, Never> { $showHideTabBar.eraseToAnyPublisher() }

    let router: Router
    let cartPublisher: AnyPublisher<[CartEntity], Never>

    init(router: Router, cartPublisher: AnyPublisher<[CartEntity], Never>) {
        self.router = router
        self.cartPublisher = cartPublisher
    }

    func start() {
        let tabBarItemFactory = TabBarItemFactory(tabBarCoordinator: self)
        let useCase = TabBarUseCase(tabBarItemFactory: tabBarItemFactory, cartPublisher: cartPublisher)
        let viewModel = TabBarViewModel(coordinator: self, useCase: useCase, showTabBarPublisher: showTabBarPublisher)
        let controller = TabBarViewController(viewModel: viewModel)
        router.setViewController(controller)
    }

    func viewWillAppear() {
        router.setNavigationBarHidden(true)
    }

    func viewDidDisAppear() {
        self.router.setNavigationBarHidden(false)   
    }

    func showTabBar() {
        showHideTabBar = true
    }

    func hideTabBar() {
        showHideTabBar = false
    }
    
    func showCheckout() {
        CheckoutCoordinator(router: router).start()
    }
}
