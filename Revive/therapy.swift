import SwiftUI

// Message Model
struct Message: Identifiable {
    let id = UUID()
    let sender: MessageSender
    let text: String
    let timestamp: Date
}

enum MessageSender {
    case user
    case therapist
}

// Therapist Model
struct Therapist {
    let name: String
    let specialization: String
    let profileImage: String
}

// Main View
struct TherapyMessagingView: View {
    @State private var messages: [Message] = [
        Message(sender: .therapist, text: "Hi there! How are you feeling today?", timestamp: Date()),
        Message(sender: .user, text: "I've been struggling with anxiety lately.", timestamp: Date()),
        Message(sender: .therapist, text: "I'm here to help. Can you tell me more about what's been going on?", timestamp: Date())
    ]
    
    @State private var newMessageText: String = ""
    
    let currentTherapist = Therapist(
        name: "Dr. Emily Rodriguez",
        specialization: "Anxiety & Stress Management",
        profileImage: "therapist_profile"
    )
    
    var body: some View {
        VStack {
            // Therapist Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(currentTherapist.name)
                        .font(.headline)
                    Text(currentTherapist.specialization)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    // Potential action like video call or more options
                }) {
                    Image(systemName: "video.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: .gray.opacity(0.2), radius: 2)
            
            // Chat Messages
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message Input Area
            HStack {
                TextField("Type a message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(8)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(8)
                }
                .disabled(newMessageText.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
    
    func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        
        let newMessage = Message(
            sender: .user,
            text: newMessageText,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        newMessageText = ""
        
        // Simulate therapist response after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let response = Message(
                sender: .therapist,
                text: "I hear you. Let's discuss this further.",
                timestamp: Date()
            )
            messages.append(response)
        }
    }
}

// Message Bubble Component
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer()
                messageContent
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            } else {
                messageContent
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                Spacer()
            }
        }
    }
    
    var messageContent: some View {
        VStack(alignment: message.sender == .user ? .trailing : .leading) {
            Text(message.text)
                .padding()
                .foregroundColor(.primary)
            
            Text(formatTimestamp(message.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 4)
        }
    }
    
    func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Preview for Development
struct TherapyMessagingView_Previews: PreviewProvider {
    static var previews: some View {
        TherapyMessagingView()
    }
}
