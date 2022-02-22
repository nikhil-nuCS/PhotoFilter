//
//  BasePresenter.swift
//  PhotoFilter
//
//  Created by NK.
//

import Foundation
import UIKit

internal class BasePresenter: NSObject {
    private(set) weak var presenterBaseViewController: UIViewController?

    init(viewController: UIViewController?) {
        super.init()
        setBaseViewControllerForPresenter(baseViewController: viewController)
    }
    
    private func setBaseViewControllerForPresenter(baseViewController: UIViewController?) {
        presenterBaseViewController = baseViewController
    }
}
