<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>
               
                <v-flex>
                    <v-card>
                        <v-toolbar color="#7EC0EE" dark>
                            <v-toolbar-title>Registered Users</v-toolbar-title>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                        <v-list two-line v-if="Users.length>0">
                            <v-card v-for="(user, index) in Users" :ripple="{ center: true }"
                                :key="new Date().getMilliseconds()+index">
                                <v-list-tile :key="index+new Date().getTime()" avatar>
                                    <v-list-tile-content>
                                        <v-list-tile-title>UserID: {{ (user.userID) }}
                                        </v-list-tile-title>
                                        <v-list-tile-title>RideCredit Balance: {{ (user.rideCreditBalance) }}
                                        </v-list-tile-title>
                                    </v-list-tile-content>
                                    <v-tooltip top>
                                        <template v-slot:activator="{ on }">
                                            <v-btn icon x-smal :ripple="{ center: true }">
                                                <v-icon color="grey lighten-1"
                                                    @click="selectedVenue=venue;banUser(user.userID)" v-on="on">
                                                    remove_circle_outline</v-icon>
                                            </v-btn>
                                        </template>
                                        <span>Ban User</span>
                                    </v-tooltip>

                                </v-list-tile>
                                <v-divider v-if="index + 1 < Users.length" :key="index"></v-divider>
                            </v-card>
                        </v-list>
                        <InfiniteLoading @infinite="loadAllRegisteredUsers" spinner="waveDots"></InfiniteLoading>
                        <loading :active.sync="isLoading" :can-cancel="false" :is-full-page="fullPage">
                        </loading>
                    </v-card>
                </v-flex>
            </v-layout>
        </v-container>
    </v-app>
</template>

<script>
    import EmbarkJS from '../../embarkArtifacts/embarkjs';
    import Loading from 'vue-loading-overlay';
    import 'vue-loading-overlay/dist/vue-loading.css';
    import InfiniteLoading from 'vue-infinite-loading';
    import Swal from 'sweetalert2'
    export default {
        components: {
            InfiniteLoading,
            Loading
        },
        data() {
            return {
                Users: [],
                RhodeITSmartContract: {},
                fullPage:true,
                isLoading:false
            }
        },
        mounted() {
            EmbarkJS.onReady((err) => {
                console.log(err)
                this.RhodeITSmartContract = require('../../embarkArtifacts/contracts/RhodeIT')
            })
        },
        methods: {
            loadAllRegisteredUsers: async function ($state) {
                let This = this
                this.RhodeITSmartContract.methods.getAllRegisteredUserKeys().call({
                    gas: 8000000
                }).then((keys, err) => {
                    if (!err) {
                        console.log(keys)
                        $state.loaded()   
                        keys.forEach((key) => {
                            This.RhodeITSmartContract.methods.getUsercredit().call({
                                gas: 8000000,
                                from:key
                            }).then((credit, err) => {
                                if (!err) {
                                    This.Users.push({
                                        userID: key,
                                        rideCreditBalance: credit
                                    })
                                }
                            })
                        })
                    }
                }).catch((err) => {
                    console.log(err)
                    This.error('Something went wrong whilst loading registered users')
                })
        $state.complete()
            },
            banUser: async function (userID) {
                console.log(`Banning user ${userID}`)
            },
            error(message) {
                Swal.fire({
                    type: 'error',
                    title: 'Error',
                    text: message,
                    allowOutsideClick: true
                })
            },
            success(message) {
                Swal.fire(
                    'Success',
                    message,
                    'success'
                )
            }
        }
    }
</script>

<style>

</style>