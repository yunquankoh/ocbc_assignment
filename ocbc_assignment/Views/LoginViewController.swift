
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    static let defaultManager = LoginViewController()
    var authorisationHeader: String = ""
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        loginButton.layer.cornerRadius = 15
        
        usernameTextField.delegate = self;
        passwordTextField.delegate = self;
    }
    
    @IBAction func Login(_ sender: UIButton) {
        self.view.endEditing(true)
        validate()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validate() {
        do {
            
            _ = try usernameTextField.validatedText(validationType: ValidatorType.username)
            _ = try passwordTextField.validatedText(validationType: ValidatorType.password)
          
            loginButton.isEnabled = false
            
          RequestRouter.login(username: usernameTextField.text!, password: passwordTextField.text!).send(LoginResponse.self, then: loginResponse)
            
            loginButton.isEnabled = true
            
        } catch let error as ValidationError {
            print(error)
            showAlert(for: "\(error.localizedDescription)")
            loginButton.isEnabled = true
            return
        } catch (let error) {
            print(error)
            showAlert(for: "System Error")
            loginButton.isEnabled = true
            return
        }
    }
    
    var loginResponse: HandleResponse<LoginResponse> {
        
        return {[weak self] (response) in
            DispatchQueue.main.async {
                self?.loginButton.isEnabled = true
            }
            switch response {
            case .failure(let error):
              self?.showAlert(for: "Login failed.Please try again")
        
                return
            case .success(let value):
                if(value.status?.caseInsensitiveCompare("success") == .orderedSame){
                      print("success")
                  if let authHeader = value.token {
                    LoginViewController.defaultManager.authorisationHeader = authHeader
                    print("authHeader \(authHeader)")
                  }
                      self?.goToBalancePage()
                    
                }  else {
                  self?.showAlert(for: "Network error.Please try again")
                    return
                }
                
            }
        }
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
}

