//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//    @Published var location: CLLocation?
//    var coreLocationManager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        coreLocationManager.delegate = self
//        coreLocationManager.requestAlwaysAuthorization()
//        coreLocationManager.allowsBackgroundLocationUpdates = true
//        coreLocationManager.pausesLocationUpdatesAutomatically = false
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.startUpdatingLocation()
//        case .denied, .restricted:
//            manager.requestWhenInUseAuthorization()
//            print("denied")
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//        default:
//            return
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        DispatchQueue.main.async {
//            self.location = location
//        }
//        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("didFailWithError: \(error.localizedDescription)")
//    }
//}
