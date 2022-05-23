//
//  LocationSearchBar.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/22/22.
//

import SwiftUI

struct LocationSearchBar: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var isSearchBarVisible: Bool
    @Binding var searchText: String
    @State var localSearchText: String = ""
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        
        GeometryReader { geometry in
            Group {
                
                // Dark overlay
                if isSearchBarVisible {
                    Color.black.opacity(0.8)
                        .onTapGesture{
                            isSearchBarVisible = !isSearchBarVisible
                        }
                }
                
                // Custom location search bar
                HStack{
                    if isSearchBarVisible {
                        ZStack(alignment:.leading) {
                            TextField("", text: $localSearchText, onCommit: {
                                weatherManager.fetchWeatherforecast(forText: localSearchText)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    if weatherManager.isValidSearch {
                                        searchText = localSearchText
                                    }
                                    else{
                                       searchText = ""
                                        localSearchText = ""
                                   }
                                }
                                
                                isSearchBarVisible = !isSearchBarVisible
                            })
                            .padding()
                            if localSearchText.isEmpty {
                                Text("Search...")
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .onTapGesture {
                            if isSearchBarVisible {
                                weatherManager.fetchWeatherforecast(forText: localSearchText)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    if weatherManager.isValidSearch {
                                        searchText = localSearchText
                                    }
                                    else{
                                       searchText = ""
                                        localSearchText = ""
                                   }
                                }
                            }
                            isSearchBarVisible = !isSearchBarVisible
                        }
                        .padding()
                }
                .foregroundColor((colorScheme == .dark && !isSearchBarVisible) ? .white : .black)
                .background(isSearchBarVisible ? .white : .clear)
                .frame(height: 64)
                .cornerRadius(24)
                .padding(.vertical, geometry.safeAreaInsets.top + 8)
                .padding(.horizontal, isSearchBarVisible ? 20 : (geometry.size.width - 84))
            }
            .ignoresSafeArea()
        }
    }
}

struct LocationSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchBar(isSearchBarVisible: .constant(true), searchText: .constant(""))
            .environmentObject(WeatherManager())
    }
}
