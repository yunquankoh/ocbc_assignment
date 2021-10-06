
import Foundation
import Alamofire


typealias HandleResponse<T: CodableInit> = (Result<T>) -> Void

protocol HandleAlamoResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponse<T: CodableInit>(_ response: DataResponse<Data>, then: CallResponse<T>)
}

struct NetworkError: LocalizedError {
    let statusCode: String
    init(code: String) {
        self.statusCode = code
    }
    var errorDescription: String? { return statusCode }
    var failureReason: String? { return statusCode }
}

extension HandleAlamoResponse {
  
  func handleResponse<T: CodableInit>(_ response: DataResponse<Data>, then: CallResponse<T>) {

      switch response.result {
      case .failure( _):
          if let jsonValue = response.result.value {
              print("JSON: \(jsonValue)")
          }
         print("\(String(describing: response.response?.statusCode))")
          then?(Result<T>.failure(NetworkError(code: "response code \(response.response?.statusCode ?? 0)")))
      case .success(let value):
          do {
              let modules = try T(data: value)
              then?(Result<T>.success(modules))
          }catch {
              then?(Result<T>.failure(error))
          }
      }
  }
}
