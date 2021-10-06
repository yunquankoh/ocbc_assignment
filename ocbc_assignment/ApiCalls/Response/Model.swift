
import Foundation

/// Default response to check for every request since this's how this api works.
struct DefaultResponse: Codable, CodableInit {
  var status: Int
}


struct LoginResponse: Codable, CodableInit {
  var status: String?
  var token: String?
  
  
  enum CodingKeys: String, CodingKey {
    case status
    case token
    
  }
}


struct BalancesResponse: Codable, CodableInit {
  var status: String?
  var balance: Double?
  
  
  enum CodingKeys: String, CodingKey {
    case status
    case balance
    
  }
}



struct PayeesResponse: Codable, CodableInit {
  var status: String?
  var data: [PayeeDataDetails]?
  
  enum CodingKeys: String, CodingKey {
    case status
    case data
  }
}


struct PayeeDataDetails: Codable, CodableInit {
  var id: String?
  var accountNo: String?
  var accountHolderName: String?
  
  
  enum CodingKeys: String, CodingKey {
    case id
    case accountNo
    case accountHolderName
  }
}



struct TransactionsResponse: Codable, CodableInit {
  var status: String?
  var data: [TransactionDataDetails]?
  
  enum CodingKeys: String, CodingKey {
    case status
    case data
  }
}

struct TransactionDataDetails: Codable, CodableInit {
  var id: String?
  var type: String?
  var amount: Double?
  var currency: String?
  var description: String?
  var date: String?
  var from: FromToDetails?
  var to: FromToDetails?
  
  
  enum CodingKeys: String, CodingKey {
    case id
    case type
    case amount
    case currency
    case description
    case date
    case from
    case to
  }
}

struct FromToDetails: Codable, CodableInit {
    var accountNo: String?
    var accountHolderName: String?
    
    enum CodingKeys: String, CodingKey {
        case accountNo
        case accountHolderName
    }
}

struct TransferResponse: Codable, CodableInit {
  var status: String?
  var data: TransferDataDetails?
  
  enum CodingKeys: String, CodingKey {
    case status
    case data
    
  }
}

struct TransferDataDetails: Codable, CodableInit {
  var id: String?
  var recipientAccountNo: String?
  var amount: Double?
  var date: String?
  var description: String?
  
  
  enum CodingKeys: String, CodingKey {
    case id
    case recipientAccountNo
    case amount
    case date
    case description
  }
}
