

class AuthGuard {
    authenticate() {
        return true;
    }
    // shouldRoute() {
        // return true;
//         // If use Redux, we can dispatch an action to tell UI that `RouteGuard` is running.
//     // This is useful for displaying loading indicators before the `shouldRoute` is complete
//         appStore.dispatch(routingActions.executeRouteGuard())

//         // Get the entire state to check whether the user is already logged in or not
//         const appState: AppState = appStore.getState() as AppState;

//         // Already logged in, pass instantly
//         if (appState.auth.loginUser && (!appState.auth.loginError || appState.auth.loginError === '')) {
//             // We can call any BackEnd APIs to rebuild the entire app state that are needed for the 
//             // routed component to be rendered correctly
//             //
//             // Passed
//             return true
//         } else {
//             // Say for instance a user just opened a URL in a new tab, then we can try to load some 
//             // cookie or call some API to load user info. If the API responds successfully, 
//             // then the check has passed. From here we rebuild the entire
//             // app state for the routed component if needed

//             return UserService.loadUserStateFromCookie()
//                 .switchMap(loadedUser => loadedUser ? UserService.loadUserList() : Observable.of(false))
//                 .do(userList => {
//                     // Dispatch an action to let Reducer rebuild the state synchronize
//                     if (userList && typeof (userList) === 'object') {
//                         appStore.dispatch(actions.rebuildState(userList)))
//         }
//     }
//                 // Map to boolean result
//                 .map(userList => userList? true : false)
//                 .take(1)
// }
    // }
}

export default new AuthGuard();
