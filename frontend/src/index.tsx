
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import 'bootstrap/dist/css/bootstrap.min.css';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

const rootElement = document.getElementById('root');
if (!rootElement) throw new Error("Root element not found");

const root = ReactDOM.createRoot(rootElement);
root.render(
  // <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path='/*' element={ <App /> }>

        </Route>
      </Routes>
    </BrowserRouter>
  // </React.StrictMode>
);
