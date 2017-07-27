import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';

if (!window.web3 || !window.web3.currentProvider.isMetaMask) {
    alert('This application requires MetaMask to run.')
} else {
    // @TODO: wait for the wallet to load.
    ReactDOM.render(<App />, document.getElementById('root'));
}
