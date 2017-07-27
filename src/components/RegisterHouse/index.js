import React, { PureComponent } from 'react'

class RegisterHouse extends PureComponent {
    render() {
        const address = window.web3.eth.defaultAccount

        return (
            <div>
                <p>
                    There is no house registered on the Energy Market
                    on the address <b>{address}</b>.
                </p>
                <input type='button' label='Register house' />
            </div>
        )
    }
}

export default RegisterHouse
