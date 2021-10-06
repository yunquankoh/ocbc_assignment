
import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {
  
  var baseURL: URL { get }
  var requestURL: URL { get }
  
  var path: ServerUrls { get }
  
  
  // MARK: - Parameters
  var parameters: Parameters? { get }
  
  // MARK: - Methods
  var method: HTTPMethod { get }
  
  var encoding: ParameterEncoding { get }
  
  var urlRequest: URLRequest { get }
}


extension URLRequestBuilder {
  
  var baseURL: URL  {
    return URL(string: "http://localhost:8080/")!
  }
  
  
  var requestURL: URL {
    return baseURL.appendingPathComponent(path.rawValue)
  }
  
  var headers: HTTPHeaders {
    
    var header = HTTPHeaders()
    header["Content-Type"] = "application/json"
    header["Accept"] = "application/json"
    
    if  !LoginViewController.defaultManager.authorisationHeader.isEmpty {
        //put in sigleton object
        header["Authorization"] = LoginViewController.defaultManager.authorisationHeader
    }
   
    
    return header
  }
  
  var defaultParams: Parameters {
    let param = Parameters()
    return param
  }
  
  var encoding: ParameterEncoding {
    if method == .get {
      return URLEncoding.default
    }
    
    return JSONEncoding.default
  }
  
  var urlRequest: URLRequest {
    var request = URLRequest(url: requestURL)
    request.httpMethod = method.rawValue
    headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
    return request
  }
  
  func asURLRequest() throws -> URLRequest {
    return try encoding.encode(urlRequest, with: parameters)
  }
  
}
