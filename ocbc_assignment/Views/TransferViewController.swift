//
//  TransferViewController.swift
//  ocbc_assignment
//
//  Created by user207445 on 10/4/21.
//

import UIKit

class TransferViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var recipientTextBox: UITextField!
    @IBOutlet weak var dateTextbox: UITextField!
    @IBOutlet weak var descriptionTextbox: UITextField!
    @IBOutlet weak var amountTextBox: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    
    var payeeArray = [String]()
    var payeeAccArray = [String]()
    var payeePickerView = UIPickerView()
    
    var recipientAccountNo: String = ""
    var dateTimeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        RequestRouter.payees.send(PayeesResponse.self, then: payeesResponse)
        
        payeePickerView.delegate = self;
        payeePickerView.dataSource = self;
        recipientTextBox.delegate = self;
        dateTextbox.delegate = self;
        
        recipientTextBox.inputView = payeePickerView
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        
        dateTextbox.inputView = datePicker
        dateTextbox.text = formatDate(date: Date())
        
        cancelButton.layer.cornerRadius = 15
        transferButton.layer.cornerRadius = 15
        
        dateTimeString = formatDateBE(date: NSDate() as Date)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return payeeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return payeeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        recipientTextBox.text = payeeArray[row]
        recipientAccountNo = payeeAccArray[row]
        
        recipientTextBox.resignFirstResponder()
    }
    
    var payeesResponse: HandleResponse<PayeesResponse> {
        
        return {[weak self] (response) in
            
            switch response {
            case .failure(let error):
                print(LoginViewController.defaultManager.authorisationHeader)
                self?.showAlert(for: "System Error")
        
                return
            case .success(let value):
                if(value.status?.caseInsensitiveCompare("success") == .orderedSame){
                      print("success")
                
                      if let payeeData = value.data {
                          for rowData in payeeData {
                              self?.payeeAccArray.append("\(rowData.accountNo!)")
                              self?.payeeArray.append("\(rowData.accountHolderName!)")
                          }
                      }
                
                }  else {
                  self?.showAlert(for: "Please login again")
                    return
                }
                
            }
        }
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextbox.text = formatDate(date: datePicker.date)
        dateTimeString = formatDateBE(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd h:mm:ss a"
        return formatter.string(from: date)
    }
    
    func formatDateBE(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.goToBalancePage()
    }
    
    func goToBalancePage() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "BalanceViewController") as? BalanceViewController else {
            return
        }
        guard let navigationController = navigationController else {
            return
        }
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func transferButton(_ sender: UIButton) {
        self.view.endEditing(true)
        validate()
    }
    
    func validate() {
        do {
            
            _ = try recipientTextBox.validatedText(validationType: ValidatorType.recipient)
            _ = try dateTextbox.validatedText(validationType: ValidatorType.datetime)
            _ = try amountTextBox.validatedText(validationType: ValidatorType.amount)
            
            cancelButton.isEnabled = false
            transferButton.isEnabled = false
            
            guard let amountValue = Double(amountTextBox.text!) else {
                showAlert(for: "Error reading amount")
                cancelButton.isEnabled = true
                transferButton.isEnabled = true
                return
            }
            
            print(recipientAccountNo)
            print(amountValue)
            print(dateTimeString)
            print(descriptionTextbox.text!)
            
            RequestRouter.transfers(recipientAccountNo: recipientAccountNo, amount: amountValue, date: dateTimeString, description: descriptionTextbox.text!).send(TransferResponse.self, then: transferResponse)
            
            cancelButton.isEnabled = true
            transferButton.isEnabled = true
            
        } catch let error as ValidationError {
            print(error)
            showAlert(for: "\(error.localizedDescription)")
            cancelButton.isEnabled = true
            transferButton.isEnabled = true
            return
        } catch (let error) {
            print(error)
            showAlert(for: "System Error")
            cancelButton.isEnabled = true
            transferButton.isEnabled = true
            return
        }
    }
    
    var transferResponse: HandleResponse<TransferResponse> {
        
        return {[weak self] (response) in
            switch response {
            case .failure(let error):
              print(error)
                self?.showAlert(for: "Transfer failed.")
                return
            case .success(let value):
                if(value.status?.caseInsensitiveCompare("success") == .orderedSame){
                      print("success")
                      self?.showAlert(for: "Transfer success")
                    return
                }  else {
                  self?.showAlert(for: "Network error.Please try again")
                    return
                }
                
            }
        }
    }
}
