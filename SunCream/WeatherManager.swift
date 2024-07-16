//import Foundation
//import WeatherKit
//import CoreLocation
//
//class WeatherManager {
//    private let weatherService = WeatherService.shared
//
//    func fetchUVIndex(for location: CLLocation, completion: @escaping (Result<Double, Error>) -> Void) {
//        Task {
//            do {
//                let weather = try await weatherService.weather(for: location)
//                let uvIndex = weather.currentWeather.uvIndex.value
//                DispatchQueue.main.async {
//                    completion(.success(Double(uvIndex)))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//}
