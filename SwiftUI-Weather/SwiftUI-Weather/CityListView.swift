//
//  CityListView.swift
//  SwiftUI-Weather
//
//  Created by Ömer Oğuz Çelikel on 5.08.2024.
//

import SwiftUI

struct CityListView: View {
    
    let cities = ["New York", "London", "Paris", "Tokyo", "Sydney", "Berlin", "Rome", "Beijing", "Moscow", "Rio de Janeiro"]
    
    var body: some View {
        List(cities, id: \.self) { city in
            Text(city)
        }
        .navigationTitle("Famous Cities")
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}
