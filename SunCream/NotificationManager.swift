//import Foundation
//import UserNotifications
//
//class NotificationManager {
//    static let shared = NotificationManager()
//
//    private init() {
//        configureNotification()
//    }
//
//    private func configureNotification() {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//            if let error = error {
//                print("알림 권한 요청 실패: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("알림 전송 실패: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func scheduleNotification(at date: Date) {
//        let content = UNMutableNotificationContent()
//        content.title = "알람"
//        content.body = "설정한 시간입니다."
//        content.sound = .default
//
//        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
//        dateComponents.second = 0
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("알람 스케줄 설정 실패: \(error.localizedDescription)")
//            }
//        }
//    }
//}
