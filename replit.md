# AI Coach - SwiftUI iOS Learning Platform

## Overview

AI Coach is a personalized learning assistant iOS application built with SwiftUI that helps users improve their skills through AI-driven learning paths, scenario-based simulators, and interactive roleplay sessions. The app features gamification elements including progress tracking, badges, achievements, and personalized recommendations to create an engaging and adaptive learning experience.

**Important:** This is a native iOS application that requires Xcode on macOS to build and run. It cannot be executed directly in Replit.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Framework**: SwiftUI (iOS native)
- **Navigation Pattern**: Tab-based navigation with 5 main sections
  - Dashboard (progress overview and quick actions)
  - Learning (learning paths and content)
  - AI Simulators (scenario-based practice)
  - AI Roleplay (interactive sessions)
  - Profile/Settings (user preferences and achievements)
- **Design System**: Centralized theme architecture
  - `AppColors.swift` - Global color palette and gradients
  - `Typography.swift` - SF Pro font system
  - `Gradients.swift` - Reusable gradient presets
- **Component Structure**: Modular view components organized by feature area
  - Authentication views
  - Dashboard components
  - Learning path builders
  - Simulator interfaces
  - Roleplay session views
  - Profile and settings screens

### Authentication & Authorization
- **Multi-provider Authentication**: Firebase Authentication
  - Email/Password authentication
  - Apple Sign-In (SSO)
  - Google Sign-In (SSO)
- **Session Management**: Firebase-based user sessions

### Data Architecture
- **Primary Database**: Firebase Firestore (NoSQL cloud database)
  - User profiles and preferences
  - Learning path configurations (preset and custom)
  - Progress tracking data
  - Achievement and badge records
  - Session history and metrics
- **Media Storage**: Firebase Storage
  - User avatars
  - Learning content assets
  - Achievement badges

### Learning Path System
- **Preset Paths**: Predefined learning tracks with predetermined outcomes
- **Custom Paths**: 3-step builder flow
  1. Information gathering
  2. Skills selection
  3. Review and confirmation
- **AI Integration**: Generated paths feed into all three practice modes (Learning, Simulators, Roleplay)

### Gamification Features
- Progress visualization (circular progress rings, timelines)
- Metrics tracking (completed sessions, scores, time spent)
- Badge and achievement system
- User avatars and profiles
- Scorecard system

## External Dependencies

### Firebase Platform
- **Firebase Authentication** - Multi-provider user authentication
- **Firebase Firestore** - Cloud-based NoSQL database for real-time data
- **Firebase Storage** - Cloud storage for media assets

### Third-Party SDKs
- **Google Sign-In SDK** - Google SSO integration
- **Apple AuthenticationServices** - Apple Sign-In (native iOS framework)
- **Lottie** - Animation framework for rich UI animations
- **Charts** - Data visualization for progress tracking and metrics

### Development Tools
- **Swift Package Manager** - Dependency management (defined in Package.swift)
- **Xcode** - Required IDE for building and running the application