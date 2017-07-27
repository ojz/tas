import React, { PureComponent } from 'react'
import propTypes from 'prop-types'

class FrontView extends PureComponent {
    static propTypes = {
        shakti: propTypes.any,
    }

    render() {
        return <p>Let's go.</p>
    }
}

export default FrontView
