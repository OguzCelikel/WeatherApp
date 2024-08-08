//
//  CityListView.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 5.08.2024.
//

import SwiftUI

struct CityListView: View {
    
    let cities: [City]
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCity: City
    
    var body: some View {
        List(cities, id: \.name) { city in
            HStack {
                Text(city.iconName) // Display the city icon
                    .font(.system(size: 32)) // Adjust size as needed
                Text(city.name) // Display the city name
                    .font(.system(size: 16))
                    .padding(8)
            }
            .onTapGesture {
                selectedCity = city
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Select a City 🏙️")
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CityListView(
                cities: cities, // Your predefined city list
                selectedCity: .constant(cities.first!)
            )
        }
    }
}


