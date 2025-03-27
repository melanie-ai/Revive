import SwiftUI

struct GroupChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: UUID(), sender: "nature_world", content: "Hey everyone! Is anyone one going to this other event.", timestamp: Date().addingTimeInterval(-3600), isCurrentUser: false, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "people_yay", content: "I fs am. I cant wait!", timestamp: Date().addingTimeInterval(-3540), isCurrentUser: false, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "you", content: "I'll be there! Can we meet up prior?", timestamp: Date().addingTimeInterval(-3300), isCurrentUser: true, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "peteDavidsonsLeftToe", content: "BRO YESS IM SO HUNGRYYY I WANT TO HIT ALL THE FOOD COURTS BEFORE IT STARTS", timestamp: Date().addingTimeInterval(-3000), isCurrentUser: false, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "mike_design", content: "Fiiinneee I know you are a big back so sure.", timestamp: Date().addingTimeInterval(-2700), isCurrentUser: false, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "crazzzyyyKev", content: "can somone cashapp me 5$ i want to buy a sandwich", timestamp: Date().addingTimeInterval(-2750), isCurrentUser: false, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "CrAzYaCe", content: "dude what sandwich cost 5$ lol", timestamp: Date().addingTimeInterval(-2700), isCurrentUser: false, profileImage: "person.circle.fill"),

        ChatMessage(id: UUID(), sender: "designguru", content: "Also whos cashapping you 5$?????", timestamp: Date().addingTimeInterval(-2700), isCurrentUser: false, profileImage: "person.circle.fill"),
        
        ChatMessage(id: UUID(), sender: "mike_design", content: "BROOOKKKIEEEEEEEE", timestamp: Date().addingTimeInterval(-2890), isCurrentUser: false, profileImage: "person.circle.fill")
    ]
    
    @State private var showingInfoSheet = false
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
               

                Spacer()
                
                VStack(spacing: 2) {
                    Text("Design Team")
                        .font(.headline)
                    
                    Text("Active now")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: { showingInfoSheet = true }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.primary)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(UIColor.systemGray4))
                    .offset(y: 10)
            }
            
            // Messages List
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubbles(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .onChange(of: messages) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            scrollProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input Area
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(UIColor.systemGray4))
                
                HStack(spacing: 12) {
                    Button(action: { isShowingImagePicker = true }) {
                        Image(systemName: "camera")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        TextField("Message...", text: $messageText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        
                        Button(action: {}) {
                            Image(systemName: "mic")
                                .foregroundColor(.primary)
                                .padding(.trailing, 8)
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    
                    Button(action: sendMessage) {
                        Image(systemName: messageText.isEmpty ? "heart" : "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemBackground))
            }
        }
        .sheet(isPresented: $showingInfoSheet) {
            GroupInfoView()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            Text("Image Picker Would Go Here")
                .padding()
        }
    }
    
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = ChatMessage(
            id: UUID(),
            sender: "you",
            content: messageText,
            timestamp: Date(),
            isCurrentUser: true,
            profileImage: "person.circle.fill"
        )
        
        messages.append(newMessage)
        messageText = ""
    }
}

struct MessageBubbles: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if !message.isCurrentUser {
                Image(systemName: message.profileImage)
                    .font(.system(size: 28))
                    .clipShape(Circle())
                    .foregroundColor(.blue)
            } else {
                Spacer()
            }
            
            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 2) {
                if !message.isCurrentUser {
                    Text(message.sender)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.leading, 2)
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    if message.isCurrentUser {
                        Text(formatTime(message.timestamp))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(message.isCurrentUser ? Color.blue : Color(UIColor.systemGray6))
                        .foregroundColor(message.isCurrentUser ? .white : .primary)
                        .cornerRadius(18)
                    
                    if !message.isCurrentUser {
                        Text(formatTime(message.timestamp))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if message.isCurrentUser {
                Image(systemName: message.profileImage)
                    .font(.system(size: 28))
                    .clipShape(Circle())
                    .foregroundColor(.blue)
            } else {
                Spacer()
            }
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct GroupInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 12) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            Text("Design Team")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("4 members · Created on March 12")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .listRowInsets(EdgeInsets())
                }
                
                Section(header: Text("Members")) {
                    ForEach(["Mike Johnson", "Taylor Swift", "You", "Alex Chen"], id: \.self) { member in
                        HStack {
                            Image(systemName: member == "You" ? "person.fill" : "person")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color(UIColor.systemGray6))
                                .clipShape(Circle())
                            
                            Text(member)
                                .font(.body)
                            
                            Spacer()
                            
                            if member == "You" {
                                Text("Admin")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.primary)
                            Text("Mute Notifications")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(.primary)
                            Text("Add Members")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(.primary)
                            Text("View Media & Files")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                Section {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Report Group")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            Text("Leave Group")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Group Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ChatMessage: Identifiable, Equatable{
    let id: UUID
    let sender: String
    let content: String
    let timestamp: Date
    let isCurrentUser: Bool
    let profileImage: String
}

struct GroupChatView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatView()
    }
}
