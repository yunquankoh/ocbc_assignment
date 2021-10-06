
import Foundation
import Alamofire

enum RequestRouter: URLRequestBuilder {

    case login(username: String, password: String)
    case balances
    case payees
    case transactions
    case transfers(recipientAccountNo: String, amount: Double, date: String, description: String)
    
    
    // MARK: - Path
    internal var path: ServerUrls {
        switch self {
        case .login:
          return .login
          
        case .balances:
          return .balances
        case .payees:
          return .payees
        case .transactions:
          return .transactions
        case .transfers:
          return .transfers
               
        }
    }

    // MARK: - Parameters
    internal var parameters: Parameters? {
      var params = defaultParams
        switch self {
        case .login(let username, let password):
            params["username"] = username
            params["password"] = password
        case .transfers(let recipientAccountNo, let amount, let date, let description ):
            params["recipientAccountNo"] = recipientAccountNo
            params["amount"] = amount
            params["date"] = date
            params["description"] = description
        default: break
        }
        return params
    }
    
  // MARK: - Methods
  internal var method: HTTPMethod {
      switch self {
      case .login, .transfers:
          return .post
      default:
          return .get
      }
   }
    
    
}
