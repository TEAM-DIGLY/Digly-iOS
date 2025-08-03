import Foundation

struct APIConstants {
    static let isServerDevelopment = true
    static let baseUrl = isServerDevelopment ? "https://digly.shop" : ""
    
    static let developmentURL = "http://localhost:8080"
    static let productionURL = "http://digly.shop"
}
