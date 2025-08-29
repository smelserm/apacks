import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const Home = () => {
  const { user, token } = useAuth();

  return (
    <div className="card">
      <h1>Welcome to Apacks</h1>
      <p>A modern user management system built with Go and React.</p>
      
      {token ? (
        <div>
          <div className="alert alert-success">
            <strong>Welcome back!</strong> You are logged in.
          </div>
          <div style={{ marginTop: '20px' }}>
            <Link to="/profile" className="btn btn-success">
              View Your Profile
            </Link>
          </div>
        </div>
      ) : (
        <div>
          <div className="alert alert-info">
            <strong>Get started:</strong> Please log in to access your profile.
          </div>
          <div style={{ marginTop: '20px' }}>
            <Link to="/login" className="btn btn-primary">
              Login
            </Link>
          </div>
        </div>
      )}
      
      <div style={{ marginTop: '40px' }}>
        <h2>Features</h2>
        <ul>
          <li>Secure JWT Authentication</li>
          <li>User Profile Management</li>
          <li>RESTful API</li>
          <li>Modern React Client</li>
          <li>Go Backend with Gin Framework</li>
        </ul>
      </div>
    </div>
  );
};

export default Home;
