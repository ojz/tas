import Front from './Front'

// https://github.com/ReactTraining/react-router/tree/v3/docs

export default function createRoutes (store) {
  return [
    {
      path: '/',
      component: Front,
      // onEnter: (nextState, replace) => {},
    },
    // {
    //   path: '*',
    //   indexRoute: NotFoundRoute(store),
    // },
  ]
}
