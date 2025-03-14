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
        Property(id: 1, name:"Chill out at Petta's beachside Villa", location:"1298 Sycamore Street, Fairview, TX 75069",
 price: "02/23/2025", image: "House1"),
        Property(id: 2, name: "Mountain Cabin", location: "2217 Pinecrest Drive, Lakeshore, CA 96150", price: "$01/3/2025", image: "House2"),
        Property(id: 3, name: "City Apartment", location:"482 Maplewood Lane, Brookhaven, NY 11719",
 price: "2/21/2025", image: "House3"),
        Property(id: 4, name: "Countryside Cottage", location: "8743 Willowbrook Court, Meadowvale, IL 60007", price: "07/15/2025", image: "House4"),
        Property(id: 5, name: "Anyone up for a game?", location: "Malibu", price: "04/19/2025", image: "House5"),
        Property(id: 6, name: "WATCH PARTY AT MY HOUSE!!", location: "NJ", price: "09/23/2025", image: "House6"),
        Property(id: 7, name: "maing pasta&pizza anyone want some????", location: "New York", price: "$250/night", image: "House7"),
        Property(id: 8, name: "Countryside Cottage", location: "Tuscany", price: "02/23/2025", image: "House8")
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
                                .foregroundColor(selectedCategory == category ? .white : .black)
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
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .clipped()
            Text(property.name)
                .font(.headline)
                .lineLimit(1)
            Text(property.location)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(property.price)
                .font(.subheadline)
                .bold()
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
#Preview {
    HomeView()
}
