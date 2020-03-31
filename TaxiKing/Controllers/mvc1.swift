//
//  mvc1.swift
//  TaxiKing
//
//  Created by ANKIT YADAV on 29/03/20.
//  Copyright © 2020 ANKIT YADAV. All rights reserved.
//

import UIKit

class mvc1: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let datepicker : UIDatePicker = UIDatePicker()
    var leavingPicker: UIPickerView!
    var goingPicker: UIPickerView!
    var passengers = "1"
    
    var toolBar = UIToolbar()
    var passengerPicker  = UIPickerView()
    
    let placearr1 = ["VIT Vellore","VIT Chennai","Chennai Airport","Bangalore Airport","Vellore Railway Station","Chennai Railway Station"]
    let placearr2 = ["VIT Vellore","VIT Chennai","Chennai Airport","Bangalore Airport","Vellore Railway Station","Chennai Railway Station"]
    let passengerArr = ["1","2","3","4"]
    
    @IBOutlet weak var leavingFromField: CustomTextField!
    @IBOutlet weak var goingToField: CustomTextField!
    @IBOutlet weak var calanderBttn: UIButton!
    @IBOutlet weak var passengersBttn: UIButton!
    @IBOutlet weak var searchBttn: UIButton!
    @IBOutlet weak var doneBttn: UIButton!
    @IBAction func searchBttn(_ sender: Any) {
        self.performSegue(withIdentifier: "search_perfoemed", sender: self)
    }
    //MARK:-  SET UP PASSENGER PICKER
    @IBAction func selectPassenger(_ sender: Any) {
        passengerPicker = UIPickerView.init()
        passengerPicker.delegate = self
        passengerPicker.backgroundColor = UIColor.white
        passengerPicker.setValue(UIColor.black, forKey: "textColor")
        passengerPicker.autoresizingMask = .flexibleWidth
        passengerPicker.contentMode = .center
        passengerPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(passengerPicker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
        
        // Heptic Feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        passengerPicker.removeFromSuperview()
    }
    //MARK:- SET UP CALENDER PICKER
    @IBAction func calanderOpen(_ sender: Any) {
        // set up date picker
        datepicker.datePickerMode = UIDatePicker.Mode.date
        datepicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        let _ : CGSize = datepicker.sizeThatFits(CGSize.zero)
        datepicker.frame = CGRect(x:0.0, y:528, width:414, height:216)
        self.view.addSubview(datepicker)
        
        
        // Show done Bttn and picker
        doneBttn.isHidden = false
        datepicker.isHidden = false
        
        // Heptic Feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @IBAction func doneBttn(_ sender: Any) {
        datepicker.isHidden = true
        doneBttn.isHidden = true
    }
    
    
    
    
    // MARK:- For setting up picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.leavingPicker {
        return 1
        }
        else if pickerView == self.goingPicker {
            return 1
        }
        else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.leavingPicker {
        return placearr1[row]
        }
        else if pickerView == self.goingPicker{
            return placearr2[row]
        }
        else{
            return passengerArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.leavingPicker {
        return placearr1.count
        }
        else if pickerView == self.goingPicker{
            return placearr2.count
        }
        else{
            return passengerArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.leavingPicker {
        leavingFromField.text = placearr1[row]
        }
        else if pickerView == self.goingPicker{
            goingToField.text = placearr2[row]
        }
        else{
            passengersBttn.setTitle(passengerArr[row] + " passenger", for: .normal)
        }
    }
    
    // func for formatting and printing date
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
        calanderBttn.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDateChanged(sender: datepicker)
        doneBttn.isHidden = true
        
        //to delete the line in the navBar
        self.tabBarController?.tabBar.layer.zPosition = -1
        searchBttn.layer.cornerRadius = 22
        doneBttn.layer.cornerRadius = 22
        
        // MARK: -setting up Picker View
        leavingPicker = UIPickerView()
        goingPicker = UIPickerView()
        leavingFromField.inputView = leavingPicker
        goingToField.inputView = goingPicker
        
        // Picker delegates
        leavingPicker?.dataSource = self
        leavingPicker?.delegate = self
        goingPicker?.dataSource = self
        goingPicker?.delegate = self
        
        leavingPicker.backgroundColor = UIColor.white
        goingPicker.backgroundColor = UIColor.white
        
        
        //Hide Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Code below this is for hiding keyboard

       deinit {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
       }
       
       func hideKeyboard(){
           view.resignFirstResponder()
       }
       
       @objc func keyboardwilchange(notification: Notification){
       }
       
       //UITextFieldDeligate Methods
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           hideKeyboard()
           return true
       }
       
       //Hide when touch outside keyboard
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
       
       override var prefersStatusBarHidden: Bool
           {
           return false
       }
    
    

}
