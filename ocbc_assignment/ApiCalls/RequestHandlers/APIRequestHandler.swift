
import Foundation
import Alamofire



/// Response completion handler beautified.
typealias CallResponse<T> = ((Result<T>) -> Void)?


/// API protocol, The alamofire wrapper
protocol APIRequestHandler: HandleAlamoResponse {
    
    /// Calling network layer via (Alamofire), this implementation can be replaced anytime in one place which is the protocol itsel, applied everywhere.
    ///
    /// - Parameters:
    ///   - decoder: Codable confirmed class/struct, Model.type.
    ///   - requestURL: Server request.
    ///   - completion: Results of the request, general errors cases handled.
    /// - Returns: Void.
 // func send<T: CodableInit>(_ decoder: T.Type, then: CallResponse<T>)
}

extension APIRequestHandler  where Self: URLRequestBuilder  {
  
  func send<T: CodableInit>(_ decoder: T.Type, then: CallResponse<T>) {
      request(self).validate().responseData {(response) in
          self.handleResponse(response, then: then)
      }
  }
}
