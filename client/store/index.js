'use strict'

export const state = () => ({
  users: 0
})

export const mutations = {
  setUsers (state, users) {
    state.users = users
  }
}

// Or:
// import Vuex from 'vuex'
// import mutations from './mutations'

// const createStore = () => {
//   return new Vuex.Store({
//     state: {
//       counter: 0,
//     },
//     // mutations

//     mutations: {
//       increment (state) {
//         state.counter++
//       }
//     }
//   })
// }

// export default createStore

