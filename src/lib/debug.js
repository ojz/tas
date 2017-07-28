import { EnergyMarket } from 'contracts'

export async function listHouses() {
    var em = await EnergyMarket.deployed()

    const countResp = await em.countHouses.call();
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
}
