import Foundation

struct APIConstants {
    static let isServerDevelopment = true
    
    static let developmentURL = "https://digly.shop"
    static let productionURL = "https://digly.shop"
    
    static let baseUrl = isServerDevelopment ? developmentURL : productionURL
}
