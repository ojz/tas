// ------------------------------------
// Actions
// ------------------------------------

export const HOUSE_EXISTS_REQUEST = 'HOUSE_EXISTS_REQUEST'
export const HOUSE_EXISTS_SUCCESS = 'HOUSE_EXISTS_SUCCESS'
export const HOUSE_EXISTS_ERROR = 'HOUSE_EXISTS_ERROR'

export function houseExists () {
  return async (dispatch, getState) => {
  }
}

// ------------------------------------
// Action Handlers
// ------------------------------------

const ACTION_HANDLERS = {
}

// ------------------------------------
// Reducer
// ------------------------------------

const initialState = {
  inProgress: false,
  completed: false,
  error: null,
  exists: null,
}

function reducer (state = initialState, action) {
  const handler = ACTION_HANDLERS[action.type]
  return handler ? handler(state, action) : state
}

export default { initialState, reducer }
