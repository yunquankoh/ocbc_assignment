
import Foundation

struct ValidationError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    
    case password
    case username
    case recipient
    case datetime
    case amount
  
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
       
        case .password: return PasswordValidator()
        case .username: return UserNameValidator()
        case .recipient: return RecipientValidator()
        case .datetime: return DateTimeValidator()
        case .amount: return AmountValidator()
            
        }
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 1 else {
            throw ValidationError("username must not be blank." )
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 1 else {
            throw ValidationError("Passwords must not be blank.") }
        return value
    }
}

struct RecipientValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 1 else {
            throw ValidationError("Recipient must not be blank.") }
        return value
    }
}

struct DateTimeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 1 else {
            throw ValidationError("Date of transfer must not be blank.") }
        return value
    }
}

struct AmountValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 1 else {
            throw ValidationError("Amount must not be blank.") }
        guard let valueDouble = Double(value) else {
            throw ValidationError("Invalid amount.") }
        return value
    }
}
