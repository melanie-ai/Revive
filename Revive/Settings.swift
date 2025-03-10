import SwiftUI

struct SettingsRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            Text(title)
        }
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isNotificationsEnabled = true
    @State private var isDarkModeEnabled = false
    @State private var selectedLanguage = "English"

    var body: some View {
        NavigationStack {
            List {
                // Account Section
                Section(header: Text("Account")) {
                    NavigationLink(destination: Text("Edit Profile")) {
                        SettingsRow(icon: "person.circle.fill", title: "Edit Profile")
                    }
                    NavigationLink(destination: Text("Security Settings")) {
                        SettingsRow(icon: "lock.fill", title: "Security")
                    }
                }

                // Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle("Notifications", isOn: $isNotificationsEnabled)
                        .toggleStyle(SwitchToggleStyle())

                    Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                        .onChange(of: isDarkModeEnabled) { newValue in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                        }

                    Picker("Language", selection: $selectedLanguage) {
                        Text("English").tag("English")
                        Text("Spanish").tag("Spanish")
                        Text("French").tag("French")
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                // Help & Support Section
                Section(header: Text("Help & Support")) {
                    NavigationLink(destination: Text("Help Center")) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help")
                    }
                    NavigationLink(destination: Text("Privacy Policy")) {
                        SettingsRow(icon: "hand.raised.fill", title: "Privacy")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

