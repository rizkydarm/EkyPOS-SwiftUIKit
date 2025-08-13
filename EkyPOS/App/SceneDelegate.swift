//
//  SceneDelegate.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import RealmSwift
import Device

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var splitViewController: UISplitViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
//        deleteRealmDatabase()
        
        window = UIWindow(windowScene: windowScene)
        var rootVC: UINavigationController?
        if Device.size() > .screen6_7Inch {
            rootVC = UINavigationController(rootViewController: SalesCheckoutSplitViewController())
        } else {
            rootVC = UINavigationController(rootViewController: SalesViewController())
        }
        rootVC?.isNavigationBarHidden = true
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func checkMultitaskingState(_ windowScene: UIWindowScene) {
        let screenSize = windowScene.screen.bounds.size
        let safeAreaInsets = windowScene.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
        let interfaceOrientation = windowScene.interfaceOrientation
        
        if windowScene.traitCollection.horizontalSizeClass == .compact {
            // Likely in Split View or Slide Over
            if safeAreaInsets.top > 0 && safeAreaInsets.left > 0 {
                print("Split View mode")
            } else {
                print("Slide Over mode")
            }
        } else if windowScene.traitCollection.horizontalSizeClass == .regular {
            // Full Screen mode or regular (non-split view)
            if screenSize.width == windowScene.screen.bounds.width {
                print("Full Screen mode")
            } else {
                print("Regular mode or large screen with no multitasking")
            }
        }
    }

    
    func deleteRealmDatabase() {
        guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else { return }
        
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        
        for url in realmURLs {
            do {
                try FileManager.default.removeItem(at: url)
                print("Deleted Realm file at: \(url)")
            } catch {
                print("Error deleting Realm file: \(error.localizedDescription)")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

