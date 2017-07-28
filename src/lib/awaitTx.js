import Promise from 'bluebird'

// wait until a block is mined which contains the tx.
// will throw after lim blocks
export async function awaitTx (txHash, limit = 15) {
  const getBlock = Promise.promisify(window.web3.eth.getBlock)
  const getTransaction = Promise.promisify(window.web3.eth.getTransaction)

  return new Promise(async function (resolve, reject) {
    let filter

    const killFilter = () => filter.stopWatching((err) => {
      if (err) {
        reject(err)
      }
    })

    // check all new blocks
    filter = window.web3.eth.filter('latest').watch(async function (err, blockHash) {
      if (err) {
        killFilter()
        reject(err)
      }

      const block = await getBlock(blockHash)

      if (block.transactions.indexOf(txHash) > -1) {
        killFilter()
        resolve()
      }

      if (limit <= 0) {
        killFilter()
        reject(new Error('Transaction wasnt found in time.'))
      }
      limit--
    })

    // check if not already mined:
    const tx = await getTransaction(txHash)
    if (tx !== null) {
      killFilter()
      resolve()
    }
  })
}
