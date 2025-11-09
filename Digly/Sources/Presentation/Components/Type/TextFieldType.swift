import SwiftUI

enum TextFieldType {
    case id
    /// - Note: id는 하기 상황에서도 사용됩니다.
    ///     ``HMAuthTextField`` 내부 일반 `TextField`의 focus 상태관리
    ///     ``InquiryView`` 내부 Title 입력 `TextField`의 focus 상태관리
    
    case password
    /// - Note: password는 하기 상황에서도 사용됩니다.
    ///     ``HMAuthTextField`` 내부 `SecureField`의 focus 상태관리
    ///     ``InquiryView`` 내부 Content 입력 `TextField`의 focus 상태관리
    
    case oldPassword
    case newPassword
    case confirmPassword
    
    case nickname
    
    case machinePassword
    case confirmMachinePassword
    
    case introduction
    
    var title: String {
        switch self {
        case .id: 
            "아이디"
        case .password: 
            "비밀번호"
        case .oldPassword:
            "기존 비밀번호"
        case .newPassword:
            "새 비밀번호"
        case .confirmPassword:
            "비밀번호 확인"
        case .nickname:
            "닉네임"
        case .machinePassword:
            "SEGYM 비밀번호"
        case .confirmMachinePassword:
            "SEGYM 비밀번호 확인"
        case .introduction:
            "소개글"
        }
    }
    
    var placeholder: String {
        switch self {
        case .id: 
            "3~20자, 영문/숫자 조합"
        case .password, .newPassword:
            "8~20자, 영문 대소문자 구분, 숫자/특수문자 조합"
        case .oldPassword:
            "사용 중인 비밀번호를 입력해 주세요"
        case .confirmPassword:
            "8~20자, 영문 대소문자 구분, 숫자/특수문자 조합"
        case .nickname: 
            "3~12자, 영문 대소문자 구분/한글/숫자/특수문자"
        case .machinePassword:
            "SEGYM 비밀번호"
        case .confirmMachinePassword:
            "SEGYM 비밀번호"
        case .introduction:
            "자유롭게 표현해 보세요!"
        }
    }
    
    var maxLength: Int {
        switch self {
        case .id, .password, .oldPassword, .newPassword, .confirmPassword: 20
        case .nickname: 12
        case .introduction: 40
        case .machinePassword, .confirmMachinePassword: 4
        }
    }
    
    var isSecure: Bool {
        switch self {
        case .password, .oldPassword, .newPassword, .confirmPassword, .machinePassword, .confirmMachinePassword: true
        case .id, .nickname, .introduction: false
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .id, .password, .oldPassword, .newPassword, .confirmPassword: .asciiCapable
        case .nickname, .introduction: .default
        case .machinePassword, .confirmMachinePassword: .numberPad
        }
    }
}
