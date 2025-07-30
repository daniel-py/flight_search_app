# Flight Search App

A Flutter application for searching flights using the AviationStack API.

## Getting Started

This project is a starting point for a Flutter application.

### Setup

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure API Key**
   - Create a `.env` file in the root directory
   - Add your AviationStack API key:
     ```
     AVIATION_STACK_API_KEY=your_actual_api_key_here
     ```
   - Get your free API key from [AviationStack](https://aviationstack.com/)

3. **Run the App**
   ```bash
   flutter run
   ```

### Features

- Search flights by departure and arrival cities
- Date selection for departure
- Optional filters (direct flights, nearby airports)
- Real-time flight data from AviationStack API

### API Configuration

The app uses the AviationStack API for flight data. You need to:
1. Sign up at [aviationstack.com](https://aviationstack.com/)
2. Get your free API key
3. Add it to the `.env` file as `AVIATION_STACK_API_KEY=your_key_here`

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
