import SwiftUI
import MapKit

struct DiscoverView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedUser: User?
    @State private var showFilters = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: locationViewModel.nearbyUsers) { user in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: user.location?.latitude ?? 0,
                        longitude: user.location?.longitude ?? 0
                    )) {
                        UserMapPin(user: user) {
                            selectedUser = user
                        }
                    }
                }
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        SearchBar() // You’ll need to implement SearchBar separately (or remove this line)
                        
                        Button(action: { showFilters = true }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    if !locationViewModel.nearbyUsers.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(locationViewModel.nearbyUsers) { user in
                                    NearbyUserCard(user: user)
                                        .onTapGesture {
                                            selectedUser = user
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedUser) { user in
                UserDetailView(user: user) // Create a placeholder UserDetailView
            }
            .sheet(isPresented: $showFilters) {
                FiltersView() // Create a placeholder FiltersView
            }
        }
        .onAppear {
            if let location = locationViewModel.userLocation {
                region.center = location.coordinate
            }
        }
    }
}

struct UserMapPin: View {
    let user: User
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .offset(y: -5)
            }
        }
    }
}

struct NearbyUserCard: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(user.fullName.prefix(1))
                            .font(.title2)
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .font(.headline)
                    
                    Text(user.interests.prefix(2).joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("0.5 km")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 280)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
