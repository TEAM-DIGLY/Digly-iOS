import SwiftUI

enum ToastType {
    case error(Error)
    case errorStringWithTask(String)
    case errorWithMessage(String)
    case success(String)
    
    var text: String {
        switch self {
        case .error(let error):
            return error.localizedDescription
        case .errorStringWithTask(let taskName):
            return "\(taskName) 중 오류가 발생했어요. 다시 시도해 주세요."
        case .errorWithMessage(let message):
            return message
        case .success(let message):
            return message
        }
    }
    
    var icon: String {
        switch self {
        case .error, .errorStringWithTask, .errorWithMessage:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
    
    var button: ButtonConfig? {
        switch self {
        case .error, .errorStringWithTask, .errorWithMessage:
            return ButtonConfig(
                text: "재시도",
                type: .primary,
                onClick: {},
                disabled: false
            )
        case .success:
            return nil
        }
    }
}
