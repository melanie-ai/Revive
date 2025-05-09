import SwiftUI

struct Conversation: Identifiable {
    let id = UUID()
    let personName: String
    let avatar: String
    let lastMessage: String
    let timestamp: Date
    let unreadCount: Int
    let isOnline: Bool
}

struct ChatListView: View {
    @State private var conversations: [Conversation] = [
        Conversation(
            personName: "Lisa Johnson",
            avatar: "person.circle.fill",
            lastMessage: "Are we still meeting for coffee tomorrow?",
            timestamp: Date().addingTimeInterval(-1800),
            unreadCount: 2,
            isOnline: true
        ),
        Conversation(
            personName: "Michael Chen",
            avatar: "person.circle.fill",
            lastMessage: "What are your plans for after the event?",
            timestamp: Date().addingTimeInterval(-7200),
            unreadCount: 0,
            isOnline: false
        ),
        Conversation(
            personName: "Art Event",
            avatar: "person.3.fill",
            lastMessage: "Lorea: when is everyon going to the Art Show",
            timestamp: Date().addingTimeInterval(-86400),
            unreadCount: 5,
            isOnline: false
        ),
        Conversation(
            personName: "Therapist",
            avatar: "person.circle.fill",
            lastMessage: "can't wait to see you on Friday!",
            timestamp: Date().addingTimeInterval(-172800),
            unreadCount: 0,
            isOnline: true
        ),
        Conversation(
            personName: "Indoor Soccer Group",
            avatar: "house.fill",
            lastMessage: "Diana: Don't forget your cleats or we all running.",
            timestamp: Date().addingTimeInterval(-259200),
            unreadCount: 0,
            isOnline: false
        )
    ]
    
    @State private var searchText = ""
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations
        } else {
            return conversations.filter { $0.personName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredConversations) { conversation in
                    NavigationLink(destination: Text("Chat details for \(conversation.personName)")) {
                        ConversationRow(conversation: conversation)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Messages")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    // Action for composing new message
                }) {
                    Image(systemName: "square.and.pencil")
                }
            )
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile picture with online indicator
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: conversation.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                if conversation.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.personName)
                        .font(.headline)
                        .fontWeight(conversation.unreadCount > 0 ? .bold : .regular)
                    
                    Spacer()
                    
                    Text(formatTimestamp(conversation.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(conversation.unreadCount > 0 ? .primary : .gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            return formatter.string(from: date)
        }
    }
}

struct MessageView: View {
    var body: some View {
        ChatListView()
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
