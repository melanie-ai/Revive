import SwiftUI
import MapKit


// MARK: - Main App
struct SocialMediaApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// MARK: - MainTabView
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            TherapyMessagingView()
                .tabItem {
                    Label("Therapy", systemImage: "message")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            GroupChatView()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
        }
    }
}




// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabView()
                .previewDisplayName("Full App")
            HomeView()
                .previewDisplayName("Home View")
            MapView()
                .previewDisplayName("Map View")
            CalendarView()
                .previewDisplayName("Calendar View")
            TherapyMessagingView()
                .previewDisplayName("Therapy View")
            SettingsView()
                .previewDisplayName("Settings View")
            GroupChatView()
                .previewDisplayName("MessagesBubbles")
            
        }
    }
}

