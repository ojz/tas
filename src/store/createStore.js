import { applyMiddleware, createStore, combineReducers } from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import thunk from 'redux-thunk'
import { routerReducer, routerMiddleware } from 'react-router-redux'
import { browserHistory } from 'react-router'
import { reducer as formReducer } from 'redux-form'

import houseExists from './house/houseExists'

export default function () {
    return createStore(
        combineReducers({
            routing: routerReducer,
            form: formReducer,

            houseExists: houseExists.reducer,
        }),
        {
            houseExists: houseExists.initialstate,
        },
        composeWithDevTools(
            applyMiddleware(thunk, routerMiddleware(browserHistory))
        )
    )
}
