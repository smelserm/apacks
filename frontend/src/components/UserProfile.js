import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const UserProfile = () => {
  const { user, token, loading, fetchUserProfile } = useAuth();
  const [userData, setUserData] = useState(null);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (!token) {
      navigate('/login');
      return;
    }

    if (user) {
      setUserData(user);
    } else {
      fetchUserData();
    }
  }, [token, user, navigate]);

  const fetchUserData = async () => {
    try {
      setError(null);
      const response = await fetch('/api/v1/user', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        const data = await response.json();
        setUserData(data);
      } else {
        setError('Failed to fetch user data');
      }
    } catch (err) {
      setError('Error connecting to server');
      console.error('Error fetching user data:', err);
    }
  };

  if (!token) {
    return null; // Will redirect to login
  }

  if (loading) {
    return (
      <div className="card">
        <div className="loading">Loading user profile...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="card">
        <div className="alert alert-error">
          <strong>Error:</strong> {error}
        </div>
        <button onClick={fetchUserData} className="btn btn-primary">
          Retry
        </button>
      </div>
    );
  }

  return (
    <div className="card">
      <h1>User Profile</h1>
      
      {userData ? (
        <div className="user-info">
          <h3>User Information</h3>
          <p><strong>User ID:</strong> {userData.user_id}</p>
          <p><strong>Message:</strong> {userData.message}</p>
          
          {/* Display additional user fields if they exist */}
          {userData.email && (
            <p><strong>Email:</strong> {userData.email}</p>
          )}
          {userData.first_name && (
            <p><strong>First Name:</strong> {userData.first_name}</p>
          )}
          {userData.last_name && (
            <p><strong>Last Name:</strong> {userData.last_name}</p>
          )}
          {userData.created_at && (
            <p><strong>Created:</strong> {new Date(userData.created_at).toLocaleDateString()}</p>
          )}
        </div>
      ) : (
        <div className="alert alert-info">
          No user data available.
        </div>
      )}
      
      <div style={{ marginTop: '20px' }}>
        <button onClick={fetchUserData} className="btn btn-secondary">
          Refresh Data
        </button>
      </div>
    </div>
  );
};

export default UserProfile;
