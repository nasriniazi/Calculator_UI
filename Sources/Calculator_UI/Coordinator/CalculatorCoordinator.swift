//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-11.
//

import Foundation
import Coordinator
import UIKit
import Theme
import FeatureToggling


 protocol CalculatorCoordinatorProtocol: CoordinatorProtocol {
     func showCalculatorViewController(manager:FeatureToggleService)
}
public class CalculatorCoordinator: CalculatorCoordinatorProtocol {
    public var DI: [String : Any]?

    weak public var finishDelegate: CoordinatorFinishDelegate?

    public var navigationController: UINavigationController

    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType { .calculator }

    required public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    
    }
    public func start(){
        if let manager = DI?["manager"] as? FeatureToggleService{
         showCalculatorViewController(manager:manager)
        }
    }
    
    func showCalculatorViewController(manager:FeatureToggleService){
        let calculatorVC: CalculatorViewController = CalculatorViewController.init(nibName: "CalculatorViewController", bundle: Bundle.module)
        let caculatorViewModel = CalculatorViewModel(featureManager: manager)
        calculatorVC.viewModel = caculatorViewModel
        navigationController.pushViewController(calculatorVC, animated: true)

    }
}
