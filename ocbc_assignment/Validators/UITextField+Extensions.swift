
import UIKit.UITextField


extension UITextField {
  func validatedText(validationType: ValidatorType) throws -> String {
    let validator = VaildatorFactory.validatorFor(type: validationType)
    return try validator.validated(self.text!)
  }
}

extension UIViewController {
  
   func showAlert(for alert: String) {
      let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
  }
  
}
