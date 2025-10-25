struct PopupData {
    let type: PopupType
    let action: () -> Void
}

enum PopupType: Equatable {
    case updateMandatory
    case updateOptional
    case toggleGuideOff
    case toggleGuideOn
//    case acceptFriend(username: String)
//    case loginRequired
//    case logout
//    case deleteAccount
    
    var image: String {
        switch self {
        case .updateMandatory, .updateOptional:
            "celebrate"
        case .toggleGuideOff, .toggleGuideOn:
            "alert"
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
        case .toggleGuideOff:
            "작성 가이드를 끄시겠어요?"
        case .toggleGuideOn:
            "작성 가이드를 켜시겠어요?"
        }
    }

    var description: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "서비스를 이용하기 위해\n업데이트가 필요해요 "
        case .toggleGuideOff:
            "가이드를 끄면 작성한 내용이 삭제되며,\n자유 작성 모드로 전환됩니다."
        case .toggleGuideOn:
            "가이드를 켜면 작성한 내용이 삭제되며,\n가이드 모드로 전환됩니다."
        }
    }

    var primaryButtonText: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "업데이트 하기"
        case .toggleGuideOff:
            "끄기"
        case .toggleGuideOn:
            "사용"
        }
    }

    var secondaryButtonText: String {
        switch self {
        case .updateOptional, .toggleGuideOff, .toggleGuideOn:
            "취소"
        default:
            ""
        }
    }
}
