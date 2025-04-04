# 🛍️ Clothing Store Sales App

An iOS app designed to help small clothing store owners manage their daily sales, track customer details, and monitor performance with ease.

## ✨ Features

- **Manual Sales Entry**
  - Add products with name, price, size
  - Auto date & time logging
- **Customer Management**
  - Save and reuse customer information (name & contact number)
- **Dashboard Overview**
  - Daily profit bar chart
  - Summary: revenue, expenses, items sold, and net profit
- **Sales History**
  - View and filter past sales by date and customer
- **Customer List**
  - Access all saved customers quickly
- **Secure Login**
  - Passcode-based authentication (single store only)
- **Cloud Backup**
  - Sync data with iCloud (free-tier CloudKit)
- **iOS & iPad Support**
  - Optimized layout with iOS 18-style tab bar interface

## 🧱 Architecture

The project follows **MVVM + Clean Architecture** principles for clarity, testability, and scalability.

Presentation (SwiftUI Views) │ ├── ViewModels (Business Logic + Bindings) │ ├── UseCases (Interactors) │ ├── Repositories (Interfaces) │ └── Data Layer (CloudKit + Local Storage)


## 🛠️ Tech Stack

- **Swift 5.9+**
- **SwiftUI**
- **Combine**
- **CloudKit**
- **Charts**
- **MVVM + Clean Architecture**
- **Unit Testing**

## 📸 Screenshots

_Coming Soon_


Made with ❤️ by Anurag.
