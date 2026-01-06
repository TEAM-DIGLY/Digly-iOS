import Foundation

struct APIConstants {
    static let isServerDevelopment = true
    
    static let developmentURL = "https://digly.cloud"
    static let productionURL = "https://digly.cloud"
    
    static let baseUrl = isServerDevelopment ? developmentURL : productionURL
}
