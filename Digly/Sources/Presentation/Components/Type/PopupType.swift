struct PopupData {
    let type: PopupType
    let action: () -> Void
}

enum PopupType: Equatable {
    case updateMandatory
    case updateOptional
    case toggleGuideOff
    case toggleGuideOn
    case deleteGuideQuestion(question: String)
//    case acceptFriend(username: String)
//    case loginRequired
//    case logout
//    case deleteAccount
    
    var image: String {
        switch self {
        case .updateMandatory, .updateOptional:
            "celebrate"
        case .toggleGuideOff, .toggleGuideOn, .deleteGuideQuestion:
            "alert"
        default:
            ""
        }
    }
    
    var isOptional: Bool {
        switch self {
        case .updateMandatory: false
        default: true
        }
    }

    var isDarkMode: Bool {
        switch self {
        case .updateMandatory, .updateOptional: true
        default: false
        }
    }
    
    var isBtnHorizontal: Bool {
        switch self { default: false }
    }
    
    var title: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "휴머니아 새 버전 출시!"
        case .toggleGuideOff, .toggleGuideOn:
            "가이드 설정"
        case .deleteGuideQuestion:
            "질문을 삭제할까요?"
        }
    }

    var description: String {
        switch self {
        case .updateOptional, .updateMandatory:
            "서비스를 이용하기 위해\n업데이트가 필요해요 "
        case .toggleGuideOff:
            "가이드를 끄면 작성한 노트가\n초기화 됩니다. 가이드를 사용할까요?"
        case .toggleGuideOn:
            "가이드를 사용할 시 작성한 노트가\n초기화 됩니다. 가이드를 사용할까요?"
        case let .deleteGuideQuestion(question):
            "'\(question)' 질문과 답변이 삭제돼요.\n정말 삭제하시겠어요?"
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
        case .deleteGuideQuestion:
            "삭제"
        }
    }

    var secondaryButtonText: String {
        switch self {
        case .updateOptional, .toggleGuideOff, .toggleGuideOn, .deleteGuideQuestion:
            "취소"
        default:
            ""
        }
    }
}
