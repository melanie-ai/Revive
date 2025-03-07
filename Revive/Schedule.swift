//
//  Schedule.swift
//  Revive
//
//  Created by Melanie Laveriano on 3/7/25.
//

import SwiftUI

struct CalendarView: View {
    // Events for February 28, 2025
    @State private var events: [CalendarEvent] = {
        // Create February 28, 2025 date
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 3
        components.day = 4
        
        guard let feb28 = calendar.date(from: components) else {
            return []
        }
        
        // Create events for February 28
        return [
            CalendarEvent(
                title: "Morning Meeting",
                startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: feb28)!,
                endTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: feb28)!,
                color: .blue
            ),
            CalendarEvent(
                title: "Sunrise Event",
                startTime: calendar.date(bySettingHour: 4, minute: 0, second: 0, of: feb28)!,
                endTime: calendar.date(bySettingHour: 5, minute: 30, second: 0, of: feb28)!,
                color: .orange
            )
        ]
    }()
    
    // Set initial selected date to February 28, 2025
    @State private var selectedDate: Date = {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 3
        components.day = 4
        return calendar.date(from: components) ?? Date()
    }()
    
    @State private var showingNewEventSheet = false
    
    let hourHeight: CGFloat = 60
    let timeColumnWidth: CGFloat = 50
    
    var body: some View {
            NavigationView {
                ScrollView{
                    VStack(spacing: 0) {
                        // Date selector
                        HStack {
                            Button(action: { moveDate(by: -1) }) {
                                Image(systemName: "chevron.left")
                            }
                            
                            Spacer()
                            
                            Text(dateFormatter.string(from: selectedDate))
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: { moveDate(by: 1) }) {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding()
                        
                        // Calendar grid
                        GeometryReader { geometry in
                            HStack(alignment: .top, spacing: 0) {
                                // Time column
                                VStack(alignment: .trailing, spacing: 0) {
                                    ForEach(03..<11) { hour in
                                        Text("\(hour):00")
                                            .font(.caption)
                                            .frame(height: hourHeight, alignment: .top)
                                            .padding(.top, 12)
                                            .padding(.trailing, 10)
                                    }
                                }
                                .frame(width: timeColumnWidth)
                                
                                // Events column
                                ZStack(alignment: .topLeading) {
                                    // Hour grid lines
                                    VStack(spacing: 0) {
                                        ForEach(0..<9) { hour in
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 1)
                                                .padding(.top, hourHeight - 1)
                                        }
                                    }
                                    
                                    // Only show events for the selected date
                                    ForEach(eventsForSelectedDate()) { event in
                                        EventView(event: event, fullWidth: geometry.size.width - timeColumnWidth)
                                            .position(
                                                x: (geometry.size.width - timeColumnWidth) / 2,
                                                y: calculateYPosition(for: event)
                                            )
                                    }
                                }
                                .frame(width: geometry.size.width - timeColumnWidth)
                            }
                        }
                        .padding(.top)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading: Button("Today") {
                            // Set to February 28, 2025
                            let calendar = Calendar.current
                            var components = DateComponents()
                            components.year = 2025
                            components.month = 3
                            components.day = 3
                            selectedDate = calendar.date(from: components) ?? Date()
                        },
                        trailing: Button(action: {
                            showingNewEventSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                    )
                    .sheet(isPresented: $showingNewEventSheet) {
                        NewEventView(isPresented: $showingNewEventSheet, onSave: addEvent)
                    }
                }
            }
    }
    
    // Helper functions
    func calculateYPosition(for event: CalendarEvent) -> CGFloat {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: event.startTime)
        let hour = CGFloat(startComponents.hour ?? 0)
        let minute = CGFloat(startComponents.minute ?? 0)
        
        return hour * hourHeight + (minute / 60.0) * hourHeight + hourHeight / -0.55
    }
    
    func moveDate(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    func addEvent(_ event: CalendarEvent) {
        events.append(event)
    }
    
    // Only show events for the selected date
    func eventsForSelectedDate() -> [CalendarEvent] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.startTime, inSameDayAs: selectedDate)
        }
    }
    
    // Formatters
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
}

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let startTime: Date
    let endTime: Date
    let color: Color
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var height: CGFloat {
        CGFloat(duration / 3600) * 60 // 60 points per hour
    }
}

struct EventView: View {
    let event: CalendarEvent
    let fullWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.caption)
                .bold()
                .lineLimit(1)
            
            Text("\(timeFormatter.string(from: event.startTime)) - \(timeFormatter.string(from: event.endTime))")
                .font(.caption2)
                .lineLimit(1)
        }
        .padding(6)
        .frame(width: fullWidth * 0.9, height: event.height, alignment: .topLeading)
        .background(event.color.opacity(0.3))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(event.color, lineWidth: 2)
        )
    }
    
    // Formatter for time
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct NewEventView: View {
    @Binding var isPresented: Bool
    var onSave: (CalendarEvent) -> Void
    
    @State private var title = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var selectedColor: Color = .blue
    
    let availableColors: [Color] = [.blue, .green, .orange, .red, .purple]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Title", text: $title)
                    
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    
                    DatePicker("End Time", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Color")) {
                    HStack {
                        ForEach(availableColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(color == selectedColor ? Color.black : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                                .padding(5)
                        }
                    }
                }
            }
            .navigationTitle("New Event")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    let event = CalendarEvent(
                        title: title,
                        startTime: startTime,
                        endTime: endTime,
                        color: selectedColor
                    )
                    onSave(event)
                    isPresented = false
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

struct ContentView: View {
    var body: some View {
        CalendarView()
    }
}

struct Schedule: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
