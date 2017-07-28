import React, { Component } from 'react'
import { Provider } from 'react-redux'
import { Router, browserHistory } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'

import createStore from 'store/createStore'
import createRoutes from 'routes/createRoutes'

import { EnergyMarket } from 'contracts'

import { listHouses, listSellOrders, listBuyOrders, listenToEvents } from 'lib/debug'
import { awaitTx } from 'lib/awaitTx'

class App extends Component {
  constructor (props) {
    super(props)
    this.store = createStore()
    this.routes = createRoutes(this.store)
    this.history = syncHistoryWithStore(browserHistory, this.store)

    EnergyMarket.setProvider(window.web3.currentProvider)
  }

  async componentDidMount() {
    await listenToEvents()
    await listHouses()

    var em = await EnergyMarket.deployed()
    var addr = window.web3.eth.defaultAccount;
    var exists = await em.houseExists.call(addr)

    var result

    if (!exists) {
      console.log('creating house')
      result = await em.createHouse(addr, 0, { from: addr, gas: 1000000 })
      console.log(result);
      await awaitTx(result.tx)

      console.log('adding balance to house')
      result = await em.addBalance(addr, 60, { from: addr, gas: 1000000 })
      console.log(result);
      await awaitTx(result.tx)
    }

    const countSellOrdersResp = await em.countSellOrders.call()
    const countSellOrders = countSellOrdersResp.toNumber()

    if (countSellOrders === 0) {
      console.log('creating two sell orders')
      result = await em.sellOrder(30, window.web3.toWei('0.0005', 'ether'), { from: addr, gas: 1000000 })
      console.log(result);
      await awaitTx(result.tx)

      result = await em.sellOrder(25, window.web3.toWei('0.0002', 'ether'), { from: addr, gas: 1000000 })
      console.log(result);
      await awaitTx(result.tx)
    }

    await listSellOrders()

    console.log('creating a buy order')
    result = await em.buyOrder(100, { from: addr, gas: 1000000 })
    console.log(result);
    await awaitTx(result.tx)

    await listBuyOrders()
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
