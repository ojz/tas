import { EnergyMarket } from 'contracts'

export async function listenToEvents() {
    console.log('listening to events')

    var em = await EnergyMarket.deployed()
    var events = em.allEvents()

    events.watch(function (error, event) {
        if (!error) {
            console.log('Debug:', event.args.what, event.args.value.toNumber())
        }
    })
}

export async function listHouses() {
    console.group()
    var em = await EnergyMarket.deployed()

    const countResp = await em.countHouses.call()
    const count = countResp.toNumber()
    console.log('There are', count, 'houses on the market.')

    for (var i = 0; i < count; i++) {
        const address = await em.houseAddresses.call(i)
        const houseResp = await em.houses.call(address)

        const house = {
            index: houseResp[0].toNumber(),
            balanceKW: houseResp[1].toNumber(),
        }

        console.log('House', i, 'has address', address, 'and data', house)
    }
    console.groupEnd()
}

export async function listSellOrders() {
    console.group()
    var em = await EnergyMarket.deployed()

    const countResp = await em.countSellOrders.call()
    const count = countResp.toNumber()
    console.log('There are', count, 'sell orders on the market.')

    for (var i = 0; i < count; i++) {
        const orderResp = await em.sellOrders.call(i)
        const order = {
            address: orderResp[0],
            maxKW: orderResp[1].toNumber(),
            priceKW: orderResp[2].toNumber(),
        }
        console.log('Order', i, 'is', order)
    }
    console.groupEnd()
}

export async function listBuyOrders() {
    console.group()
    var em = await EnergyMarket.deployed()

    const countResp = await em.countBuyOrders.call()
    const count = countResp.toNumber()
    console.log('There are', count, 'buy orders on the market.')

    for (var i = 0; i < count; i++) {
        const orderResp = await em.buyOrders.call(i)

        // fetch the orders used, and the amounts.
        // const orderCountResp = await em.countBuyOrderOrders(i);
        // const orderCount = orderCountResp.toNumber();

        // const orders = await em.buyOrderOrders(i);
        // console.log(orders);
        // const amounts = await em.buyOrderAmounts(i);

        const order = {
            totalPrice: orderResp[0].toNumber(),
            companyAmount: orderResp[1].toNumber(),
            // orders: orders,
            // amounts: amounts,
        }

        console.log('Order', i, 'is', order)
    }
    console.groupEnd()
}

