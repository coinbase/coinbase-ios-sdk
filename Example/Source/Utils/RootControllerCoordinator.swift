//
//  RootControllerCoordinator.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

public enum RootControllers {
    
    case authorization
    case mainMenu
    
    var storyboardName: String {
        switch self {
        case .authorization:
            return "Authorization"
        case .mainMenu:
            return "Menu"
        }
    }
    
    var controllerIdentifier: String {
        switch self {
        case .authorization:
            return "AuthorizationController"
        case .mainMenu:
            return "MenuController"
        }
    }
    
    var animationOptions: UIView.AnimationOptions {
        switch self {
        case .authorization:
            return [.transitionFlipFromLeft]
        case .mainMenu:
            return [.transitionFlipFromRight]
        }
    }
    
}

public struct RootControllerCoordinator {
    
    public static func setRoot(_ controller: RootControllers, animated: Bool = true) {
        guard let window = UIApplication.shared.delegate?.window,
            let rootViewController = rootViewController,
            rootViewControllerIdentifier != controller.controllerIdentifier else {
            return
        }
        
        let storyboard = UIStoryboard(name: controller.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: controller.controllerIdentifier)
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        
        let setRoot = { () -> Void in
            window?.rootViewController = viewController
            rootViewControllerIdentifier = controller.controllerIdentifier
        }
        
        if animated {
            UIView.transition(with: window!, duration: 0.3, options: controller.animationOptions, animations: setRoot)
        } else {
            setRoot()
        }
    }
    
    public static var rootViewController: UIViewController? {
        let delegate = UIApplication.shared.delegate
        return delegate?.window??.rootViewController
    }
    
    private static var rootViewControllerIdentifier: String?
    
}
