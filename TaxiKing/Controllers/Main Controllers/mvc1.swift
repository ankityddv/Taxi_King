//
//  mvc1.swift
//  TaxiKing
//
//  Created by ANKIT YADAV on 29/03/20.
//  Copyright © 2020 ANKIT YADAV. All rights reserved.
//

import UIKit
import Firebase

class mvc1: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

	// Fold by cmd + option + shift + left
	
	// For all pickers
    let datepicker : UIDatePicker = UIDatePicker()
    var leavingPicker: UIPickerView!
    var goingPicker: UIPickerView!
    var passengers = "1"
	
    
	//For passenger Picker
    var toolBar = UIToolbar()
    var passengerPicker  = UIPickerView()
    
	
	// Arrays of the database
    let placearr1 = ["VIT Vellore","VIT Chennai","Chennai Airport","Bangalore Airport","Vellore Railway Station","Chennai Railway Station"]
    let placearr2 = ["VIT Vellore","VIT Chennai","Chennai Airport","Bangalore Airport","Vellore Railway Station","Chennai Railway Station"]
    let passengerArr = ["1","2","3","4"]
    
	
	// Declaring all the components
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var leavingFromField: CustomTextField!
    @IBOutlet weak var goingToField: CustomTextField!
    @IBOutlet weak var calanderBttn: UIButton!
    @IBOutlet weak var passengersBttn: UIButton!
    @IBOutlet weak var searchBttn: UIButton!
    @IBOutlet weak var messageBttn: UIBarButtonItem!
    @IBOutlet weak var doneBttn: UIButton!
    @IBAction func searchBttn(_ sender: Any) {
        self.performSegue(withIdentifier: "search_perfoemed", sender: self)
    }
	
	
    //MARK:- Set up passenger picker
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
	
	
    //MARK:- Set up calander picker
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
    
    
    // MARK:- For setting up leaving, going and passenger picker View
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
    
	
    //MARK:- func for formatting and printing date
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
        calanderBttn.setTitle(dateFormatter.string(from: sender.date), for: .normal)
    }
    
	
	//MARK:- Viewdidload()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileImage()
        dueDateChanged(sender: datepicker)
        doneBttn.isHidden = true
        
        //to delete the line in the navBar
        self.tabBarController?.tabBar.layer.zPosition = -1
        searchBttn.layer.cornerRadius = 22
        doneBttn.layer.cornerRadius = 22
        profileImageView.layer.cornerRadius = 15
        
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
        
        
        //messageBttn.action = #selector(showChatController)
        //tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        messageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
        //personView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfileController)))
    }
    
	
	//MARK:- Top Bar button functions
    @objc func showChatController(){
        let chatController = MessageVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    //@objc func showProfileController(){
      //  let profileController = ProfileVC()
        //profileController.hidesBottomBarWhenPushed = true
        //self.navigationController?.pushViewController(profileController, animated: true)
    //}
    
	
    // LOAD PROFILE IMAGE IN BAR BUTTON AND
    func fetchProfileImage(){
        //retrive image
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/profile_images")
        let imageRef = storageRef.child("\(uid).png")
        imageRef.getData(maxSize: 1*1000*1000) { (data,error) in
            if error == nil{
                print(data ?? Data.self)
                self.profileImageView.image = UIImage(data: data!)
            }
            else{
                print(error?.localizedDescription ?? error as Any)
            }
        }
    }
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = ViewController()
        loginController.signUpController = self
        present(loginController, animated: true, completion: nil)
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
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		hideKeyboard()
		return true
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
       
	// to hide the status bar(time and battery) on top
	override var prefersStatusBarHidden: Bool{
		return false
	}
    
    

}
