//
//  SceneDelegate.swift
//  StockChartTest
//
//  Created by Ara Hakobyan on 31.07.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = buildInitialScreen()
        window?.makeKeyAndVisible()
    }
    
    private func buildInitialScreen() -> UIViewController {
        let fileReader: FileReaderProtocol = FileReader()
        let viewModel: ChartViewModelType = ChartViewModel(fileReader: fileReader)
        let viewController = ChartViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

