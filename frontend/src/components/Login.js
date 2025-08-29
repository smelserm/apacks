import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const Login = () => {
  const [token, setToken] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!token.trim()) {
      setError('Please enter a token');
      return;
    }

    setLoading(true);
    setError('');

    try {
      // Test the token by making a request to the user endpoint
      const response = await fetch('/api/v1/user', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        login(token);
        navigate('/profile');
      } else {
        setError('Invalid token. Please try again.');
      }
    } catch (err) {
      setError('Error connecting to server. Please try again.');
      console.error('Login error:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="card">
      <h1>Login</h1>
      <p>Enter your JWT token to access your profile.</p>
      
      {error && (
        <div className="alert alert-error">
          <strong>Error:</strong> {error}
        </div>
      )}
      
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="token" className="form-label">
            JWT Token
          </label>
          <input
            type="text"
            id="token"
            className="form-input"
            value={token}
            onChange={(e) => setToken(e.target.value)}
            placeholder="Enter your JWT token"
            disabled={loading}
          />
        </div>
        
        <button 
          type="submit" 
          className="btn btn-primary"
          disabled={loading}
        >
          {loading ? 'Logging in...' : 'Login'}
        </button>
      </form>
      
      <div style={{ marginTop: '20px' }}>
        <h3>Demo Token</h3>
        <p>For testing purposes, you can use any string as a token since the backend currently uses a mock authentication system.</p>
        <div className="alert alert-info">
          <strong>Example:</strong> demo-token-123
        </div>
      </div>
    </div>
  );
};

export default Login;
