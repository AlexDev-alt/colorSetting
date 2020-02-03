//
//  ViewController.swift
//  colorSetting
//
//  Created by Macbook on 31.01.2020.
//  Copyright © 2020 Alex Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//MARK: - IB Outlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //slider
        redSlider.value = 0.3
        redSlider.minimumValue = 0
        redSlider.maximumValue = 1
        redSlider.tintColor = .red
        
        greenSlider.value = 0.5
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = 1
        greenSlider.tintColor = .green
        
        blueSlider.value = 0.8
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = 1
        blueSlider.tintColor = .blue
        
        //label
        redLabel.text = String(redSlider.value)
        greenLabel.text = String(greenSlider.value)
        blueLabel.text = String(blueSlider.value)
        
        //field
        redTextField.text = String(redSlider.value)
        greenTextField.text = String(greenSlider.value)
        blueTextField.text = String(blueSlider.value)
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        redTextField.keyboardType = .decimalPad
        greenTextField.keyboardType = .decimalPad
        blueTextField.keyboardType = .decimalPad
        
        // "done" button
        createDoneButton()
        
        //view
        colorView.layer.cornerRadius = 10
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(redSlider.value), alpha: 1)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
    }
    
//MARK: - IB Actions
    @IBAction func redSliderAction() {
        
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        redLabel.text = String(format: "%.2f", redSlider.value)
        redTextField.text = String(format: "%.2f", redSlider.value)
        
    }
    
    @IBAction func greenSliderAction() {
        
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        greenTextField.text = String(format: "%.2f", greenSlider.value)
        
    }
    
    @IBAction func blueSliderAction() {
        
        colorView.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        blueTextField.text = String(format: "%.2f", blueSlider.value)
        
    }
    
// MARK: - Public Methods
    func createDoneButton () {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                         target: self,
                                         action: #selector(doneClicked))
        
        toolBar.setItems([flexBarButton,doneButton], animated: false)
        
        redTextField.inputAccessoryView = toolBar
        greenTextField.inputAccessoryView = toolBar
        blueTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        var countOfpoint = 0
        
        guard let text = textField.text else { return }
        textField.text = text.replacingOccurrences(of: "00", with: "0")
        
        if  text.first == "."  {
            textField.text = "0."
        }
        
        for char in text {
            if char == "." {
                countOfpoint += 1
            }
        }
        
        if countOfpoint > 1 {
            textField.text = "0."
        }
        if text.count > 4 {
            textField.text?.removeLast()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text,
            Float(text) ?? 0.0 <= redSlider.maximumValue,
            Float(text) ?? 0.0 >= redSlider.minimumValue,
            text != "0.",
            !text.isEmpty
            else {
                
                showAllert(with: "Wrong format", and: "use digit at 0.0 to 1.0")
                return
        }
        
        if textField == redTextField {
            
            guard let redColor = redTextField.text else { return }
            colorView.backgroundColor = .red
            redSlider.value = Float(redColor) ?? redSlider.value
            colorView.backgroundColor = colorView.backgroundColor?.withAlphaComponent(CGFloat(Float(redColor) ?? redSlider.value))
            redLabel.text = redColor
            
        } else if textField == blueTextField {
            
            guard let blueColor = blueTextField.text else { return }
            colorView.backgroundColor = .blue
            blueSlider.value = Float(blueColor) ?? blueSlider.value
            colorView.backgroundColor = colorView.backgroundColor?.withAlphaComponent(CGFloat(Float(blueColor) ?? blueSlider.value ))
            blueLabel.text = blueColor
            
        } else if textField == greenTextField {
            
            guard let greenColor = greenTextField.text else { return }
            colorView.backgroundColor = .green
            greenSlider.value = Float(greenColor) ?? greenSlider.value
            colorView.backgroundColor = colorView.backgroundColor?.withAlphaComponent(CGFloat(Float(greenColor) ?? greenSlider.value))
            greenLabel.text = greenColor
            
        }
    }
}

//MARK: - UIAlertcontroller
extension ViewController {
    
    private func showAllert(with title: String, and message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.redTextField.text = String(format: "%.2f", self.redSlider.value)
            self.greenTextField.text = String(format: "%.2f", self.greenSlider.value)
            self.blueTextField.text = String(format: "%.2f", self.blueSlider.value)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
        
    }
}



