import React, { Component } from 'react'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import createStore from 'store/createStore'
import createRoutes from 'routes/createRoutes'

import { EnergyMarket } from 'contracts'
import { listHouses } from 'lib/debug'

class App extends Component {
  constructor (props) {
    super(props)
    this.store = createStore()
    this.routes = createRoutes(this.store)
    this.history = syncHistoryWithStore(browserHistory, this.store)

    EnergyMarket.setProvider(window.web3.currentProvider)
  }

  async componentDidMount() {
    await listHouses()

    var em = await EnergyMarket.deployed()
    var addr = window.web3.eth.defaultAccount;
    var exists = await em.houseExists.call(addr)

    if (!exists) {
      console.log('creating')
      const tx = await em.createHouse(addr, 0, 0, { from: addr, gas: 1000000 })
      console.log(tx)
    } else {
      console.log('deleting')
      const tx = await em.removeHouse(addr, { from: addr, gas: 1000000 })
      console.log(tx)
    }
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
