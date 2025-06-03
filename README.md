# Meetify

Meetify is a SwiftUI‐based iOS application that helps users discover, create, and join local events. Leveraging Firebase Authentication, Firestore, and real‐time location services, Meetify offers a seamless way for people to connect around shared interests—whether it’s a study group, a pickup sports game, a music jam, or a social meetup.

<p align="center">
  <img src="https://raw.githubusercontent.com/CosmasMandikonza/meetfiy/main/Resources/Screenshots/DiscoverView.png" alt="Meetify Discover Screen" width="300"/>
  <img src="https://raw.githubusercontent.com/CosmasMandikonza/meetfiy/main/Resources/Screenshots/CreateEventView.png" alt="Meetify Create Event" width="300"/>
</p>

---

## Table of Contents

1. [Features](#features)  
2. [Tech Stack](#tech-stack)  
3. [Screenshots](#screenshots)  
4. [Prerequisites](#prerequisites)  
5. [Installation & Setup](#installation--setup)  
   - [Clone the Repository](#clone-the-repository)  
   - [CocoaPods / Swift Package Manager](#cocoapods--swift-package-manager)  
   - [Firebase Configuration](#firebase-configuration)  
   - [Firestore Security Rules](#firestore-security-rules)  
6. [Project Structure](#project-structure)  
7. [Code Overview](#code-overview)  
   - [Models](#models)  
   - [ViewModels](#viewmodels)  
   - [Views](#views)  
   - [Services](#services)  
   - [Utilities](#utilities)  
8. [How to Run](#how-to-run)  
9. [Usage](#usage)  
10. [Future Improvements](#future-improvements)  
11. [Contributing](#contributing)  
12. [License](#license)  

---

## Features

- **User Authentication**  
  - Email/password sign‐up and login via Firebase Authentication  
  - Persisted sessions (auto‐login)  
  - Profile editing: update name, bio, interests, and profile image  

- **Real‐Time Location & Nearby Discovery**  
  - Track user’s current location using CoreLocation  
  - Show nearby users and events on a map (Discover tab)  
  - Filter nearby users by name/interests  

- **Event Management**  
  - Create new events with title, description, category, date/time, location, and maximum attendees  
  - Browse upcoming public events sorted by distance/time  
  - Join or leave events (RSVP)  
  - Real‐time attendee counts and “Your Event” / “Attending” labels  

- **Search & Filter**  
  - Search events by title, description, or category  
  - Filter events list dynamically as you type  
  - Pull‐to‐refresh for the events feed  

- **Clean, Card‐Based UI**  
  - SwiftUI cards for forms and lists (CreateEventView, EventCardView, ProfileView)  
  - Adaptive colors and icons per event category  
  - Smooth animations and loading indicators for async tasks  

---

## Tech Stack

- **iOS** / **SwiftUI** ( iOS 18.4+ / Xcode 16.3 )  
- **Firebase**  
  - Authentication (Email/Password)  
  - Cloud Firestore (data storage + queries)  
  - Firebase Core for initialization  
- **CoreLocation** (location permissions + services)  
- **MapKit** (Map & Annotations)  
- **Combine** / **@MainActor** for async/await and state-driven UI  
- **Swift Package Manager** for Firebase dependencies (or CocoaPods alternative)  

---

## Screenshots

> _These mockups demonstrate some key screens in Meetify. Replace with actual screenshots from your simulator or device._

### Discover (Map + Nearby Users)
![Discover](Resources/Screenshots/DiscoverView.png)

### Create New Event (Polished Card UI)
![Create Event](Resources/Screenshots/CreateEventView.png)

### Events Feed (Card List + Search Bar)
![Events](Resources/Screenshots/EventsView.png)

### Profile (User Info + Edit)
![Profile](Resources/Screenshots/ProfileView.png)

---

## Prerequisites

1. **macOS 11.0+** (Big Sur or later)  
2. **Xcode 16.3+** (Downloaded from the Mac App Store)  
3. **CocoaPods** (if you choose CocoaPods instead of Swift PM)  
   ```bash
   sudo gem install cocoapods
