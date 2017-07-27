import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';

if (!window.web3 || !window.web3.currentProvider.isMetaMask) {
    alert('This application requires MetaMask to run.')
} else {
    (async () => {
        let loop = 10
        while (loop--) {
            if (window.web3.eth.defaultAccount !== undefined) {
                ReactDOM.render(<App />, document.getElementById('root'))
                return
            }
            // sometimes MetaMask takes some time to load.
            await new Promise((resolve) => setTimeout(resolve, 100))
        }
        alert('Please unlock your MetaMask account and reload the page.')
    })()
}
