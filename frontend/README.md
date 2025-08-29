# Apacks Frontend

A modern React frontend for the Apacks user management system.

## Features

- **React 18** with modern hooks and functional components
- **React Router** for client-side routing
- **Context API** for state management
- **JWT Authentication** integration
- **Responsive Design** with modern CSS
- **Error Handling** with user-friendly messages
- **Loading States** for better UX

## Getting Started

### Prerequisites

- Node.js 16+ and npm
- Go backend running on port 8080

### Installation

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The app will open at [http://localhost:3000](http://localhost:3000).

### Available Scripts

- `npm start` - Start development server
- `npm build` - Build for production
- `npm test` - Run tests
- `npm eject` - Eject from Create React App

## Project Structure

```
frontend/
├── public/
│   └── index.html          # Main HTML file
├── src/
│   ├── components/         # React components
│   │   ├── Header.js       # Navigation header
│   │   ├── Home.js         # Home page
│   │   ├── Login.js        # Login form
│   │   └── UserProfile.js  # User profile display
│   ├── context/            # React context
│   │   └── AuthContext.js  # Authentication context
│   ├── App.js              # Main app component
│   ├── App.css             # App styles
│   ├── index.js            # Entry point
│   ├── index.css           # Global styles
│   └── reportWebVitals.js  # Performance monitoring
├── package.json            # Dependencies and scripts
└── README.md               # This file
```

## API Integration

The frontend communicates with the Go backend API:

- **Base URL**: `http://localhost:8080`
- **API Endpoints**:
  - `GET /api/v1/user` - Get user profile (requires JWT token)
  - `GET /health` - Health check
  - `GET /api/v1/ping` - Ping endpoint

## Authentication

The app uses JWT tokens for authentication:

1. Users enter a JWT token on the login page
2. The token is stored in localStorage
3. All API requests include the token in the Authorization header
4. The AuthContext manages authentication state

## Development

### Adding New Components

1. Create a new file in `src/components/`
2. Import and use in `App.js` or other components
3. Add routing if needed

### Styling

The app uses CSS classes defined in `src/index.css`. Key classes:

- `.card` - Card container
- `.btn` - Button styles
- `.alert` - Alert messages
- `.form-group` - Form styling
- `.user-info` - User data display

### State Management

The app uses React Context for global state:

- `AuthContext` - Manages authentication state
- Local state for component-specific data

## Deployment

### Build for Production

```bash
npm run build
```

This creates a `build` folder with optimized files.

### Docker Deployment

The frontend can be deployed using Docker:

```bash
# Build image
docker build -t apacks-frontend .

# Run container
docker run -p 3000:3000 apacks-frontend
```

## Troubleshooting

### Common Issues

1. **CORS Errors**: Ensure the Go backend is running and CORS is configured
2. **API Connection**: Check that the backend is running on port 8080
3. **Authentication**: Verify JWT token format and backend validation

### Development Tips

- Use browser dev tools to inspect network requests
- Check the console for error messages
- Verify API responses match expected format
