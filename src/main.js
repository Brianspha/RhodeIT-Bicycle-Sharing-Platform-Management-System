import Vue from 'vue'
import App from './App.vue'
import Router from './router'
import Vuetify from 'vuetify'
import VueAsyncData from "vue-async-data";
import 'vuetify/dist/vuetify.min.css' // Ensure you are using css-loader
import VueRecyclerviewNew from 'vue-recyclerview'
import infiniteScroll from 'vue-infinite-scroll'
import 'vue-googlemaps/dist/vue-googlemaps.css'
import VueGoogleMaps from 'vue-googlemaps'

Vue.use(VueGoogleMaps, {
  load: {
    // Google API key
    apiKey: 'AIzaSyAXwlptaSId-lWkaCP0VzCh5YAajrygxaM',
    // Enable more Google Maps libraries here
    libraries: ['places'],
    // Use new renderer
    useBetaRenderer: false,
  },
})
Vue.use(infiniteScroll)
Vue.use(VueRecyclerviewNew)
Vue.use(VueAsyncData)
Vue.use(Vuetify)
new Vue({
  render: h => h(App),
  router: Router

}).$mount('#app')