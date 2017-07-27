import React, { PureComponent } from 'react'
import { Link } from 'react-router'

class MenuView extends PureComponent {
    render() {
        return (
            <nav>
                <Link to='/market'>Market</Link>
            </nav>
        )
    }
}

export default MenuView
