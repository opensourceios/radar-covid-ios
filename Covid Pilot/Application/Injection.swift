//
//  Injection.swift
//  Covid Pilot
//
//  Created by alopezh on 08/06/2020.
//  Copyright © 2020 Indra. All rights reserved.
//

import Foundation
import Swinject
import UIKit

class Injection {
    
    private let container: Container;
    
    init() {
        
        container = Container();
        
        container.register(AppRouter.self) { r in
            AppRouter()
        }.inObjectScope(.container)
        .initCompleted {r, appRouter in
            appRouter.termsVC = r.resolve(TermsViewController.self)!
            appRouter.homeVC = r.resolve(HomeViewController.self)!
            appRouter.onBoardingVC = r.resolve(OnBoardingViewController.self)!
            appRouter.tabBarController = r.resolve(TabBarController.self)!
            appRouter.myHealthVC = r.resolve(MyHealthViewController.self)!
            appRouter.expositionVC = r.resolve(ExpositionViewController.self)!
        }
        
        container.register(PreferencesRepository.self) { r in
            UserDefaultsPreferencesRepository()
        }.inObjectScope(.container)
        
        container.register(BluetoothHandler.self) { r in
            CentralManagerBluetoothHandler()
        }.inObjectScope(.container)
        
        container.register(OnboardingCompletedUseCase.self) { r in
            OnboardingCompletedUseCase(preferencesRepository: r.resolve(PreferencesRepository.self)!)
        }.inObjectScope(.container)
        
        container.register(ExpositionUseCase.self) { r in
            ExpositionUseCase()
        }.inObjectScope(.container)
        
        container.register(BluetoothUseCase.self) { r in
            BluetoothUseCase(bluetoothHandler: r.resolve(BluetoothHandler.self) as! BluetoothHandler)
        }.inObjectScope(.container)
        
        container.register(TabBarController.self) { r in
            TabBarController(
                homeViewController: r.resolve(HomeViewController.self)!,
                myDataViewController: r.resolve(MyDataViewController.self)!,
                helpLineViewController: r.resolve(HelpLineViewController.self)!
            )
        }
        
        container.register(TermsViewController.self) { r in
            let termsVC = self.createViewController(storyboard: "Terms", id: "TermsViewController") as! TermsViewController
            termsVC.recomendationsVC = r.resolve(RecomendationsViewController.self)!
            termsVC.proximityVC = r.resolve(ProximityViewController.self)!
            return termsVC
        }
        
        container.register(RecomendationsViewController.self) {  r in
            let recVC = RecomendationsViewController()
            recVC.router = r.resolve(AppRouter.self)!
            recVC.onBoardingCompletedUseCase = r.resolve(OnboardingCompletedUseCase.self)!
            return recVC
        }
        
        container.register(ProximityViewController.self) {  r in
            let recVC = ProximityViewController()
            recVC.bluetoothUseCase = r.resolve(BluetoothUseCase.self)!
            return recVC
        }
        
        container.register(ExpositionViewController.self) {  r in
            self.createViewController(storyboard: "Exposition", id: "ExpositionViewController") as! ExpositionViewController
        }
        
        container.register(HomeViewController.self) {  r in
            let homeVC = self.createViewController(storyboard: "Home", id: "HomeViewController") as! HomeViewController
            homeVC.router = r.resolve(AppRouter.self)!
            homeVC.expositionUseCase = r.resolve(ExpositionUseCase.self)!
            return homeVC
        }
        
        container.register(MyDataViewController.self) {  r in
            self.createViewController(storyboard: "MyData", id: "MyDataViewController") as! MyDataViewController
        }
        
        container.register(HelpLineViewController.self) {  r in
            self.createViewController(storyboard: "HelpLine", id: "HelpLineViewController") as! HelpLineViewController
        }
        
        container.register(MyHealthViewController.self) {  r in
            self.createViewController(storyboard: "MyHealth", id: "MyHealthViewController") as! MyHealthViewController
        }
        
        container.register(OnBoardingViewController.self) {  r in
            let onbVC = self.createViewController(storyboard: "OnBoarding", id: "OnBoardingViewController") as! OnBoardingViewController
            
            onbVC.onBoardingCompletedUseCase = r.resolve(OnboardingCompletedUseCase.self)!
            onbVC.router = r.resolve(AppRouter.self)!
            return onbVC
        }
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    private func createViewController(storyboard: String, id: String) -> UIViewController {
        UIStoryboard(name: storyboard, bundle: Bundle.main)
        .instantiateViewController(withIdentifier: id)
    }
}
