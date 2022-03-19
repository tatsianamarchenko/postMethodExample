//
//  SceneDelegate.swift
//  Seventhproject
//
//  Created by Tatsiana Marchanka on 15.03.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		if let ws = scene as? UIWindowScene {
			let myWindow = UIWindow(windowScene: ws)
			let navVC = UINavigationController()
			let vc = RequestViewController()

			navVC.viewControllers = [vc]
			myWindow.rootViewController = navVC
			self.window = myWindow
			myWindow.makeKeyAndVisible()
		}
	}
}
