//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var locationDataManager = LocationDataManager()
//    @State private var alarmTime = Date()
//
//    var body: some View {
//        VStack {
//            if let location = locationDataManager.location {
//                Text("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
//                if let uvIndex = locationDataManager.uvIndex {
//                    Text("현재 자외선 지수: \(uvIndex)")
//                    Text(uvIndex >= 3 ? "썬크림을 바르세요!" : "오늘은 썬크림이 필요 없네요!")
//                } else {
//                    Text("자외선 지수를 불러오는 중...")
//                }
//            } else {
//                Text("위치 정보를 불러오는 중...")
//            }
//            Text("알림 시간 \(alarmTime)")
//
//            DatePicker("알람 시간 설정", selection: $alarmTime, displayedComponents: [.hourAndMinute])
//                .datePickerStyle(WheelDatePickerStyle())
//                .padding()
//                .onChange(of: alarmTime) { oldValue, newValue in
//                    locationDataManager.saveAlarmTime(date: newValue)
//                }
//        }
//        .padding()
//        .onAppear {
//            locationDataManager.locationManager.coreLocationManager.requestAlwaysAuthorization()
//            if let savedTime = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
//                alarmTime = savedTime
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationDataManager = LocationDataManager()
    @State private var alarmTime = Date()

    var body: some View {
        VStack {
            if let location = locationDataManager.location {
                Text("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
                if let uvIndex = locationDataManager.uvIndex {
                    Text("현재 자외선 지수: \(uvIndex)")
                    Text(uvIndex >= 3 ? "썬크림을 바르세요!" : "오늘은 썬크림이 필요 없네요!")
                } else {
                    Text("자외선 지수를 불러오는 중...")
                }
            } else {
                Text("위치 정보를 불러오는 중...")
            }
            
            // DatePicker 추가
            DatePicker("알람 시간 설정", selection: $alarmTime, displayedComponents: [.hourAndMinute])
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                .onChange(of: alarmTime) {
                    locationDataManager.saveAlarmTime(date: alarmTime)
                }
        }
        .padding()
        .onAppear {
            locationDataManager.coreLocationManager.requestAlwaysAuthorization()
            if let savedTime = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
                alarmTime = savedTime
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
