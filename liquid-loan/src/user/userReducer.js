const initialState = {
  data: null
}

const userReducer = (state = initialState, action) => {
  if (action.type === 'USER_LOGGED_IN')
  {
    console.log("Log in action: ", action);
    return Object.assign({}, state, {
      data: action.payload
    })
  }

  if (action.type === 'USER_LOGGED_OUT')
  {
    return Object.assign({}, state, {
      data: null
    })
  }

  return state
}

export default userReducer
