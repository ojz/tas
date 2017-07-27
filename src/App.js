import React, { Component } from 'react'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import createStore from 'store/createStore'
import createRoutes from 'routes/createRoutes'

import { EnergyMarket } from 'contracts'

class App extends Component {
  constructor (props) {
    super(props)
    this.store = createStore()
    this.routes = createRoutes(this.store)
    this.history = syncHistoryWithStore(browserHistory, this.store)

    EnergyMarket.setProvider(window.web3.currentProvider)

    // sample call
    EnergyMarket.deployed().then(async energyMarket => {
      const price = await energyMarket.companyPrice()
      console.log(price)
    })
  }

  render () {
    return (
      <Provider store={this.store}>
        <Router
          history={this.history}
          children={this.routes} />
      </Provider>
    )
  }
}

export default App
