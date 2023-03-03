//
//  File.swift
//  
//
//  Created by nasrin niazi on 2023-02-11.
//

import Foundation
import RxSwift
import RxCocoa
import FeatureToggling
import CalculatorCore
import UIKit

class CalculatorViewModel{
    let disposeBag = DisposeBag()
    var displayErrorMessage = PublishSubject<String?>()
    var showEmptyView = BehaviorRelay<Bool>(value: false)

    //MARK: enabledFeaturesList contain all feature names that user has set through FeatureToggling package presented in Features tab item
    private var featureManager: FeatureToggleService!
    var enabledFeaturesList :[String] = []
    let enabledOpeationButtons = BehaviorRelay<[[CalculatorButtons]]>(value: [])
    
    //MARK: Calculation Variables
    public var setClear :Bool = true
    ///Maximum limit of input and output numbers lenght
    var maximumInputLength = 9
    /// use CoreCalculator package for operations needed
    var coreCalculator = Calculator()
    ///this boolean bind showAllClear from coreCalculator to our UI to know whether show AC or C
    public var showAC = BehaviorRelay<Bool>(value: true)
    
    var clearType:CalculatorButtons{
        return self.showAC.value ? CalculatorButtons.allClear : CalculatorButtons.clear
    }
    ///inputNumberStr use for storing input numbers without any format
    var inputNumberStr:String = "0"
    /// displayText use for displaying formatted-commaSeprated-numbers
    var displayText = BehaviorRelay<String?>(value: nil)
   
    init(featureManager : FeatureToggleService){
        self.featureManager = featureManager
        displayText.accept("0")
    }
    func getFeatures()throws{
        guard let featureManager = self.featureManager else {return}
        do {
            try featureManager.getFeatureNames(.enabled){ features in
                self.enabledFeaturesList = features
                if self.enabledFeaturesList.count == 0 {
                    self.showEmptyView.accept(true)
                }
            }
        }catch let error as FeatureTogglingErrors{
            displayErrorMessage.onNext(error.description)
        }
        catch{
            displayErrorMessage.onNext(FeatureTogglingErrors.unknownError.description)
        }
    }
    @objc func processAction(_ sender:UIButton){
        switch sender.currentTitle {
        case "AC":
            self.clearAll()
        case "C":
            self.clear()
        case "=":
            self.evaluate()
        default:
            self.basicOperaorTapped(sender)
        }
    }
    func getEnabledOperationButtons(){
        try? getFeatures()
        guard enabledFeaturesList.count>0 else {
            return
        }
        var enabledButtons:[[CalculatorButtons]] = []
        let binaryOperations:[String] = Operations.BinaryOperations.allCases.map{$0.rawValue}
        let unaryOperations:[String] = Operations.UnaryOperatotions.allCases.map{$0.rawValue}
        var enabledDarkButtons:[CalculatorButtons] = (binaryOperations.filter(enabledFeaturesList.contains)).map{featureName in
            return CalculatorButtons.operation(featureName)
        }
        var  enabledLightButtons:[CalculatorButtons] = (unaryOperations.filter(
            enabledFeaturesList.contains)).map { featureName in
                return CalculatorButtons.unaryOperation(featureName)
            }
        enabledLightButtons.insert(self.clearType, at: 0)
        enabledDarkButtons.append(CalculatorButtons.operation("="))
        enabledButtons = [enabledDarkButtons,enabledLightButtons]
        self.enabledOpeationButtons.accept(enabledButtons)
    }
}
