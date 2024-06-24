//
//  LocationDetailView.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import SwiftUI

struct LocationDetailView: View {
    let location: Location
    
    var body: some View {
        VStack {
            Text(location.name)
                .font(.largeTitle)
                .padding()
            
            Text(location.type)
                .font(.title2)
                .padding()
            
            Text(location.dimension)
                .padding()
        }
    }
}
