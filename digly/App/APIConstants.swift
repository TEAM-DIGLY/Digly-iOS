import Foundation

struct APIConstants {
    static let isServerDevelopment = false
    static let baseUrl = isServerDevelopment ? "http://localhost:8080" : "http://digly.shop"
    
    static let developmentURL = "http://localhost:8080"
    static let productionURL = "http://digly.shop"
}
