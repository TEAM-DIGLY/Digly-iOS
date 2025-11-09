import SwiftUI

protocol FlowStepProtocol: Hashable, CaseIterable {
    var index: Int { get }
    var screenTitle: String { get }
    var progressPercentage: Double { get }
}

// Default implementation for progress percentage
extension FlowStepProtocol {
    var progressPercentage: Double {
        return Double(index + 1) / Double(Self.allCases.count)
    }
}

// Auth-specific protocol for CreateAccount flow
protocol AuthFlowStepProtocol: FlowStepProtocol {
    var textFieldType: TextFieldType { get }
    var screenTitle: LocalizedStringResource { get }
}

// Ticket-specific protocol for CreateTicket flow
protocol TicketFlowStepProtocol: FlowStepProtocol {
    var placeholderText: String { get }
}