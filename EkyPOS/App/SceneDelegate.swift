//
//  SceneDelegate.swift
//  EkyPOS
//
//  Created by Eky on 22/07/25.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var splitViewController: UISplitViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // deleteRealmDatabase()
        
        window = UIWindow(windowScene: windowScene)
        var rootNavCon: UINavigationController?

        let device = UIDevice.current.userInterfaceIdiom
        let windowWidth = window?.bounds.width ?? 0
        
        if device == .pad || device == .mac || windowWidth > 800 {
            let splitVC = SalesCheckoutSplitViewController()
            rootNavCon = UINavigationController(rootViewController: splitVC)
            rootNavCon?.isNavigationBarHidden = true
        } else {
            let salesVC = SalesViewController()
            rootNavCon = UINavigationController(rootViewController: salesVC)
            rootNavCon?.isNavigationBarHidden = false
        }
        window?.rootViewController = rootNavCon
        window?.makeKeyAndVisible()

        print("SceneDelegate.scene willConnectTo")
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
        print("SceneDelegate.sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("SceneDelegate.sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("SceneDelegate.sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("SceneDelegate.sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("SceneDelegate.sceneDidEnterBackground")
    }


}

