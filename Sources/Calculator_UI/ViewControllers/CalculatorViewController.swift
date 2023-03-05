//
//  CalculatorViewController.swift
//  
//
//  Created by nasrin niazi on 2023-02-05.
//

import UIKit
import Theme
import RxSwift
public class CalculatorViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var lightColorButtonsStackView: UIStackView!
    @IBOutlet  var darkColorButtonsStackView: UIStackView!
    
    //MARK: Variables
    var enabledDarkButtons:[CalculatorButtons] = []
    var enabledLightButtons:[CalculatorButtons] = []
    var viewModel:CalculatorViewModel!
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        self.viewModel.numberButtonTapped(sender)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if !checkIfButtonLoaded(){
            setupView()
        }
        else{
            
            bindClearButton()
        }
    }
    
    func bindClearButton(){
        self.viewModel.showAC.subscribe{event in
            DispatchQueue.main.async {
                if let showAllClear = event.element {
                    if showAllClear == false {
                        self.enabledLightButtons[0] = .clear
                        self.reloadLightButtonsStackView(self.enabledLightButtons)
                    }
                    else{
                        self.enabledLightButtons[0] = .allClear
                        self.reloadLightButtonsStackView(self.enabledLightButtons)
                    }
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    private func checkIfButtonLoaded()->Bool{
        if enabledDarkButtons.count == 0 && enabledLightButtons.count == 0 {
            return false
        }
        return true
    }
    func setupView(){
        try? self.viewModel.getFeatures()
        ///subscribe display empty view in case there is no enabled feature
        self.viewModel.showEmpty.subscribe{event in
            DispatchQueue.main.async {
                if let value = event.element,  value == true{
                    debugPrint("***showEmpty==TRUE****")

                    self.view = CustomEmptyView(delegate: self, message: Constants.emptyViewMessage)
                    return
                }
                
                else {
                    self.setupBindings()
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
    }
    func setupBindings(){
        
        ///ask viewModel to get Enabled Features
        self.viewModel.getEnabledOperationButtons()
        ///subscribe for enabled buttons result
        self.viewModel.enabledOpeationButtons.subscribe{ event in
            if let buttons = event.element,buttons.count > 1 {
                DispatchQueue.main.async {
                    self.enabledDarkButtons = buttons[0]
                    self.enabledLightButtons = buttons[1]
                    self.updateUI()
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
        ///bind diplay label to displayText String in viewModel
        self.viewModel.displayText.asObservable().bind(to: self.resultLabel.rx.text).disposed(by: viewModel.disposeBag)
        
        ///subscribe for any error which should display to the user
        self.viewModel.displayErrorMessage.subscribe { event in
            DispatchQueue.main.async {
                if let errorMessage = event.element ,  errorMessage != nil {
                    MessageDisplay.displaySimpleMessage(titleStr: "FeatureToggling Error", txtMessage: errorMessage! , owner: self)
                }
            }
        }.disposed(by: viewModel.disposeBag)
    }
    
    func updateUI(){
        self.reloadUIWithFeatures()
        bindClearButton()
    }
    ///this method configure operations buttons based on enabled features
    func reloadUIWithFeatures(){
        debugPrint("enabledDarkButtons=\(enabledDarkButtons)")
        debugPrint("enabledLightButtons=\(enabledLightButtons)")
        self.reloadDarkButtonsStackView(enabledDarkButtons)
        reloadLightButtonsStackView(enabledLightButtons)
        
    }
}

//MARK: setup UI based on features selected by user
extension CalculatorViewController{
    func reloadDarkButtonsStackView( _ enabledDarkButtons: [CalculatorButtons]){
        let group = createButtons(enabledDarkButtons)
        darkColorButtonsStackView.removeAllArrangedSubviews()
        darkColorButtonsStackView.addArrangedSubviews(group)
    }
    func reloadLightButtonsStackView( _ enabledLightButtons: [CalculatorButtons]){
        let group = createButtons(enabledLightButtons )
        
        lightColorButtonsStackView.removeAllArrangedSubviews()
        lightColorButtonsStackView.addArrangedSubviews(group)
    }
    func createButtons(_ buttonTypes:[CalculatorButtons])->[UIButton]{
        return buttonTypes.map { buttonType in
            let button = buttonType.themeClasseForType
            button.setTitle(buttonType.description, for: .normal)
            //            button.isHighlighted = viewModel.isActiveButton(button: buttonType)
            button.addTarget(self.viewModel, action:  #selector(viewModel.processAction(_:)), for: .touchUpInside)
            return button
        }
    }
}

