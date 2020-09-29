//

// Copyright (c) 2020 Gobierno de España
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// SPDX-License-Identifier: MPL-2.0
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK: - Outlet.
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var languageSelectorButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepbullet1Label: UILabel!
    @IBOutlet weak var selectorView: BackgroundView!
    @IBOutlet weak var stepbullet2Label: UILabel!
    @IBOutlet weak var stepbullet3Label: UILabel!
    
    // MARK: - Properties
    var router: AppRouter?
    var localesKeysArray: [String] = []
    var localesArray: [String: String?]!
    var localizationRepository: LocalizationRepository!
    
    private var currentLocale: String = "es-ES"
    private var pickerPresenter: PickerPresenter?

    //MARK: - View Life Cycle Methods.

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadLocaleValues()
    }

    //MARK: - Action methods.
    
    @IBAction func onContinue(_ sender: Any) {
        router?.route(to: .onBoarding, from: self)
    }
    
    @IBAction func selectLanguage(_ sender: Any) {
        pickerPresenter?.openPicker(title: "ACC_LANGUAGE_SELECTOR_PICKER".localized)
    }
}

//MARK: - Accesibility.
extension WelcomeViewController {
    
    func setupAccessibility() {
        
        languageSelectorButton.isAccessibilityElement = true
        languageSelectorButton.accessibilityLabel = "ACC_BUTTON_SELECTOR_SELECT".localized
        languageSelectorButton.accessibilityHint = "ACC_HINT".localized

        continueButton.setTitle("ONBOARDING_CONTINUE_BUTTON".localized, for: .normal)
        continueButton.isAccessibilityElement = true
        continueButton.accessibilityLabel = "ACC_BUTTON_CONTINUE".localized
        continueButton.accessibilityHint = "ACC_HINT".localized

        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "ACC_WELCOME_TITLE".localized
        titleLabel.accessibilityTraits.insert(UIAccessibilityTraits.header)
    }
}

//MARK: - Picker
extension WelcomeViewController: UIPickerViewDelegate, UIPickerViewDataSource, PickerDelegate {

    var containerView: UIView {
        get {
            view
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localesKeysArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key = localesKeysArray[row]
        return localesArray[key] ?? ""

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let key = localesKeysArray[row]
        self.languageSelectorButton.setTitle(self.localesArray[key, default: ""], for: .normal)
        localizationRepository.setLocale(key)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = (view as? UILabel) ?? UILabel()
        let key = localesKeysArray[row]
        let text = localesArray[key] ?? ""
        label.isAccessibilityElement = true
        label.accessibilityLabel = (text ?? "") + "ACC_SELECTED".localized
        label.textAlignment = .center
        label.text = text
        
        return label
    }

    func onDone() {
        if currentLocale != localizationRepository.getLocale() {
            showAlertOk(title: "LOCALE_CHANGE_LANGUAGE".localized,
                             message: "LOCALE_CHANGE_WARNING".localized,
                             buttonTitle: "ALERT_OK_BUTTON".localized,
                             buttonVoiceover: "ACC_BUTTON_ALERT_OK".localized) { _ in
                exit(0)
            }
        }
    }
}

//MARK: - Private.
private extension WelcomeViewController {
    
    func setupView() {
        
        selectorView.image = #imageLiteral(resourceName: "tabBarBG") 
        
        let picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        pickerPresenter = PickerPresenter(picker: picker)
        pickerPresenter?.delegate = self
        setupAccessibility()
    }
    
    func loadLocaleValues() {

        if let locale = localizationRepository.getLocale() {
            currentLocale = locale
        }

        localesArray = localizationRepository.getLocales()

        let keys = Array(self.localesArray.keys) as [String]
        if let currentLanguage = localizationRepository.getLocale() {
            languageSelectorButton.setTitle(localesArray[currentLanguage, default: ""], for: .normal)
        }

        guard let firstKey = keys.filter({ $0.contains(currentLocale) }).first else {
            self.localesKeysArray = keys
            return
        }
        let otherKeys = keys.filter {!$0.contains(currentLocale)}
        self.localesKeysArray.append(firstKey)
        self.localesKeysArray += otherKeys
    }
}
