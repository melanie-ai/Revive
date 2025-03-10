import Foundation

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

    @State private var isNotificationsEnabled = true

    @State private var isDarkModeEnabled = false

    @State private var selectedLanguage = "English"



    var body: some View {

        NavigationStack {

            List {

                // Account Section

                Section("Account") {

                    NavigationLink {

                        Text("Edit Profile")

                    } label: {

                        SettingsRow(icon: "person.circle.fill", title: "Edit Profile")

                    }



                    NavigationLink {

                        Text("Security Settings")

                    } label: {

                        SettingsRow(icon: "lock.fill", title: "Security")

                    }

                }



                // Preferences Section

                Section("Preferences") {

                    Toggle(isOn: $isNotificationsEnabled) {

                        Label("Notifications", systemImage: "bell.fill")

                    }



                    Toggle(isOn: $isDarkModeEnabled) {

                        Label("Dark Mode", systemImage: "moon.fill")

                            .preferredColorScheme(isDarkModeEnabled ? .dark : .light)

                    }



                    Picker("Language", selection: $selectedLanguage) {

                        Text("English").tag("English")

                        Text("Spanish").tag("Spanish")

                        Text("French").tag("French")

                    }

                    .pickerStyle(.menu) // Optional: Display style for the Picker

                }



                // Help & Support Section

                Section("Help & Support") {

                    NavigationLink {

                        Text("Help Center")

                    } label: {

                        SettingsRow(icon: "questionmark.circle.fill", title: "Help")

                    }



                    NavigationLink {

                        Text("Privacy Policy")

                    } label: {

                        SettingsRow(icon: "hand.raised.fill", title: "Privacy")

                    }

                }

            }

            .navigationTitle("Settings")

        }

    }

}
