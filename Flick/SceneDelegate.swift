//
//  SceneDelegate.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import IQKeyboardManagerSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let userDefaults = UserDefaults.standard
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // TODO: Double check with design and test on actual device
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200

        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let loginViewController = LoginViewController()
        let homeViewController = HomeViewController()
        var rootViewController: UIViewController
        if let token = AccessToken.current,
            !token.isExpired,
            let _ = userDefaults.string(forKey: Constants.UserDefaults.authorizationToken) {
            // User is logged in and we have the necessary authorization token to make backend requets for user.
            rootViewController = homeViewController
        } else {
            // User is logged out.
            rootViewController = loginViewController
        }
//        let navigationController = UINavigationController(rootViewController: rootViewController)

//        let navigationController = UINavigationController(rootViewController: ListViewController(list: MediaList(lstId: "1", lstName: "some name", lstPic: "", isFavorite: true, isPrivate: true, isWatched: true, collaborators: [], owner: UserProfile(userId: "", username: "", firstName: "", lastName: "", profileId: "", profilePic: ProfilePicture(id: 1, salt: "", kind: "", baseUrl: "", assetUrls: AssetUrls(original: "", large: "", small: ""), createdAt: "", updatedAt: ""), bio: nil, phoneNumber: nil, socialIdToken: nil, socialIdTokenType: nil, ownerLsts: nil, collabLsts: nil), shows: nil, tags: nil)))
        let navigationController = UINavigationController(rootViewController: EditListViewController())
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()


    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

