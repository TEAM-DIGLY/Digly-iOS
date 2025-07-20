struct PopupData {
    let type: PopupType
    let action: () -> Void
}

enum PopupType: Equatable {
    case updateMandatory
    case updateOptional
//    case acceptFriend(username: String)
//    case loginRequired
//    case logout
//    case deleteAccount
    
    var image: String {
        switch self {
        case .updateMandatory, .updateOptional:
            "celebrate"
//        default:
//            ""
        }
    }
    
    var isOptional: Bool {
        switch self {
        case .updateMandatory: false
        default: true
        }
    }
    
    var isBtnHorizontal: Bool {
        switch self { default: false }
    }
    
    var title: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "휴머니아 새 버전 출시!"
        }
    }
    
    var description: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "서비스를 이용하기 위해\n업데이트가 필요해요 "
        }
    }
    
    var primaryButtonText: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "업데이트 하기"
        }
    }
    
    var secondaryButtonText: String {
        switch self {
        case .updateOptional:
            "나중에 하기"
        default:
            ""
        }
    }
}
