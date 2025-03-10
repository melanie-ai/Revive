//
//  HomeView.swift
//  Revive
//
//  Created by Melanie Laveriano on 3/7/25.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    @State private var categories: [String] = ["All", "Beach", "Mountain", "City", "Countryside"]
    @State private var properties: [Property] = [
        Property(id: 1, name: "Beachside Villa", location: "Malibu", price: "$200/night", image: "House1.jpg"),
        Property(id: 2, name: "Mountain Cabin", location: "Aspen", price: "$150/night", image: "house2"),
        Property(id: 3, name: "City Apartment", location: "New York", price: "$250/night", image: "house3"),
        Property(id: 4, name: "Countryside Cottage", location: "Tuscany", price: "$180/night", image: "house4")
    ]
    
    var filteredProperties: [Property] {
        properties.filter { property in
            (selectedCategory == "All" || property.category == selectedCategory) &&
            (searchText.isEmpty || property.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for places", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color.blue : Color(.systemGray5))
                                                                .foregroundColor(selectedCategory == category ? .white : Color(.label))
                                .cornerRadius(20)
                                .onTapGesture {
                                    selectedCategory = category
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 5)
                
                // Property List (Vertical)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredProperties) { property in
                            PropertyCard(property: property)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Explore")
            .background(Color(.systemBackground))
        }
    }
}
// Property Model
struct Property: Identifiable {
    let id: Int
    let name: String
    let location: String
    let price: String
    let image: String
    var category: String {
        if name.contains("Beach") { return "Beach" }
        if name.contains("Mountain") { return "Mountain" }
        if name.contains("City") { return "City" }
        return "Countryside"
    }
}
// Property Card View
struct PropertyCard: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(property.image)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(10)
                .clipped()
            Text(property.name)
                .font(.headline)
                .foregroundColor(Color(.label))
                .lineLimit(1)
            Text(property.location)
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
            Text(property.price)
                .font(.subheadline)
                .bold()
                .padding(.top, 5)
                .foregroundColor(Color(.label))
        }
        .padding()
        .background(Color(.secondarySystemBackground)) // Adaptive card background
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    HomeView()
}
