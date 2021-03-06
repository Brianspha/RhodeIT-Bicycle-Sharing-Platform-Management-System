import AddBicycle from '../components/AddBicycleView.vue'
import RegisterDockingStation from '../components/AddDockingStationView.vue'
import RegisteredDockingStations from '../components/RegisteredDockingStationsView.vue'
import RegisteredBicycles from '../components/RegisteredBicyclesView.vue'
import RegisteredUsers from '../components/RegisteredUsersView.vue'
import UpdateContract from '../components/UpdateContractView.vue'

import Vue from 'vue'
import VueRouter from "vue-router";
Vue.use(VueRouter)

export default new VueRouter({
    routes: [{
            path: "/",
            redirect: "RegisterDockingStation"
        },
        {
            name: 'registerDockingStations',
            path: "/RegisterDockingStation",
            component: RegisterDockingStation
        },
        {
            name: 'dockingStations',
            path: "/RegisteredDockingStations",
            component: RegisteredDockingStations
        },
        {
            name: 'registerBicycle',
            path: "/AddBicycle",
            component: AddBicycle
        },
        {
            name: 'registeredBicycles',
            path: "/RegisteredBicycles",
            component: RegisteredBicycles
        },
        {
            name: 'registeredUsers',
            path: "/RegisteredUsers",
            component: RegisteredUsers
        },
        {
            name: 'updateContract',
            path: "/UpdateContract",
            component: UpdateContract
        }
    ],
    mode: "history"
})