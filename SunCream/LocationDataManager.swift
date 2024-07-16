//import Foundation
//import CoreLocation
//
//class LocationDataManager: ObservableObject {
//    @Published var location: CLLocation?
//    @Published var uvIndex: Double?
//
//    let locationManager = LocationManager()
//    private let weatherManager = WeatherManager()
//    private let notificationManager = NotificationManager.shared
//
//    init() {
//        locationManager.$location
//            .assign(to: &$location)
//        loadAlarmTime()
//    }
//
//    func fetchUVIndex() {
//        guard let location = location else { return }
//        weatherManager.fetchUVIndex(for: location) { result in
//            switch result {
//            case .success(let uvIndex):
//                self.uvIndex = uvIndex
//                if uvIndex >= 3 {
//                    self.notificationManager.sendNotification(title: "자외선 지수 경고", body: "현재 자외선 지수는 \(uvIndex)입니다. 썬크림을 바르세요!")
//                } else {
//                    self.notificationManager.sendNotification(title: "자외선 지수", body: "현재 자외선 지수는 \(uvIndex)입니다. 오늘은 썬크림이 필요 없네요!")
//                }
//            case .failure(let error):
//                print("날씨 정보를 가져오는 데 실패했습니다: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func saveAlarmTime(date: Date) {
//        UserDefaults.standard.set(date, forKey: "alarmTime")
//        notificationManager.scheduleNotification(at: date)
//    }
//
//    func loadAlarmTime() {
//        if let date = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
//            notificationManager.scheduleNotification(at: date)
//        }
//    }
//}
import Foundation
import CoreLocation
import Combine
import WeatherKit
import UserNotifications

class LocationDataManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var location: CLLocation?
    @Published var uvIndex: Double?
    var coreLocationManager = CLLocationManager()
    private let weatherService = WeatherService.shared

    override init() {
        super.init()
        coreLocationManager.delegate = self
        coreLocationManager.requestAlwaysAuthorization()
        coreLocationManager.allowsBackgroundLocationUpdates = true
        coreLocationManager.pausesLocationUpdatesAutomatically = false
        configureNotification()
        loadAlarmTime()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // alert 구현
            manager.requestWhenInUseAuthorization()
            print("denied")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.location = location
            self.fetchUVIndex(for: location)
        }
        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }

    private func fetchUVIndex(for location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                DispatchQueue.main.async {
                    self.handleUVIndex(weather.currentWeather.uvIndex)
                }
            } catch {
                print("날씨 정보를 가져오는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }

    private func handleUVIndex(_ uvIndex: UVIndex) {
        let uvValue = uvIndex.value
        DispatchQueue.main.async {
            self.uvIndex = Double(uvValue)
        }
        print("현재 자외선 지수: \(uvValue)")
        if uvValue >= 3 {
            sendNotification(title: "자외선 지수 경고", body: "현재 자외선 지수는 \(uvValue)입니다. 썬크림을 바르세요!")
        } else {
            sendNotification(title: "자외선 지수", body: "현재 자외선 지수는 \(uvValue)입니다. 오늘은 썬크림이 필요 없네요!")
        }
    }

    private func configureNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            }
        }
    }

    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 전송 실패: \(error.localizedDescription)")
            }
        }
    }

    // 알람 시간 저장
    func saveAlarmTime(date: Date) {
        UserDefaults.standard.set(date, forKey: "alarmTime")
        scheduleNotification(at: date)
    }

    // 알람 시간 불러오기
    func loadAlarmTime() {
        if let date = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
            scheduleNotification(at: date)
        }
    }

    // 알람 설정
    private func scheduleNotification(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "설정한 시간입니다."
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알람 스케줄 설정 실패: \(error.localizedDescription)")
            }
        }
    }
}
