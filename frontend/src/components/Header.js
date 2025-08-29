import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const Header = () => {
  const { user, token, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <header style={{
      backgroundColor: '#333',
      color: 'white',
      padding: '1rem 0',
      boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
    }}>
      <div className="container" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Link to="/" style={{ color: 'white', textDecoration: 'none', fontSize: '1.5rem', fontWeight: 'bold' }}>
          Apacks
        </Link>
        
        <nav>
          <ul style={{ listStyle: 'none', margin: 0, padding: 0, display: 'flex', gap: '2rem' }}>
            <li>
              <Link to="/" style={{ color: 'white', textDecoration: 'none' }}>
                Home
              </Link>
            </li>
            {token ? (
              <>
                <li>
                  <Link to="/profile" style={{ color: 'white', textDecoration: 'none' }}>
                    Profile
                  </Link>
                </li>
                <li>
                  <button 
                    onClick={handleLogout}
                    style={{
                      background: 'none',
                      border: 'none',
                      color: 'white',
                      cursor: 'pointer',
                      fontSize: '1rem'
                    }}
                  >
                    Logout
                  </button>
                </li>
              </>
            ) : (
              <li>
                <Link to="/login" style={{ color: 'white', textDecoration: 'none' }}>
                  Login
                </Link>
              </li>
            )}
          </ul>
        </nav>
      </div>
    </header>
  );
};

export default Header;
