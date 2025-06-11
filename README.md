# Newsie - News App

A modern Flutter News App built using **Clean Architecture** and **BLoC**, with offline caching, dependency injection, responsive layout, and full test coverage.

## Features
- **Clean Architecture**: Well-structured and maintainable codebase using domain-driven principles.
- **BLoC State Management**: Separation of business logic and UI using `flutter_bloc`.
- **Internet Connectivity Checker**: Automatically switches to offline mode using `connectivity_plus`.
- **Offline Storage with Hive**: Articles are cached using `hive` when offline access is needed.
- **Dependency Injection**: `get_it` for service locator pattern.
- **Routing with GoRouter**: Type-safe and declarative routing.
- **Responsive UI**: Adaptive layout across different screen sizes (mobile, tablet).
- **Unit & Widget Tests with Mockito**: 100% code coverage, fully tested and mock-driven.

## Tech Stack

- **Flutter**
- **BLoC**
- **Hive**
- **GetIt**
- **GoRouter**
- **Internet Connection Checker Plus**
- **Mockito**
