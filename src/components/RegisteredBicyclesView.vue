<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>

                <v-flex>
                    <v-card>
                        <v-toolbar color="#7EC0EE" dark>
                            <v-toolbar-title>Registered Bicycles</v-toolbar-title>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                        <v-list two-line v-if="bicycles.length>0">
                            <v-card v-for="(bicycle, index) in bicycles" :ripple="{ center: true }"
                                :key="new Date().getMilliseconds()+index">
                                <v-list-tile :key="index+new Date().getTime()" avatar>
                                    <v-list-tile-content>
                                        <v-list-tile-title>UserID: {{ (bicycle.bikeID) }}
                                        </v-list-tile-title>
                                        <v-list-tile-title>RideCredit Balance: {{ (bicycle.dockedAt) }}
                                        </v-list-tile-title>
                                    </v-list-tile-content>
                                    <v-tooltip top>
                                        <template v-slot:activator="{ on }">
                                            <v-btn icon x-smal :ripple="{ center: true }">
                                                <v-icon color="grey lighten-1"
                                                    @click="selectedVenue=venue;deRegisterBicycle(bicyle.bikeId)"
                                                    v-on="on">
                                                    remove_circle_outline</v-icon>
                                            </v-btn>
                                        </template>
                                        <span>DeRegister</span>
                                    </v-tooltip>

                                </v-list-tile>
                                <v-divider v-if="index + 1 < bicycles.length" :key="index"></v-divider>
                            </v-card>
                        </v-list>
                        <InfiniteLoading @infinite="loadAllRegisteredBicycles" spinner="waveDots"></InfiniteLoading>
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
                bicycles: [],
                RhodeITSmartContract: {},
                fullPage: true,
                isLoading: false
            }
        },
        mounted() {
            EmbarkJS.onReady((err) => {
                console.log(err)
                this.RhodeITSmartContract = require('../../embarkArtifacts/contracts/RhodeIT')
            })
        },
        methods: {
            loadAllRegisteredBicycles: async function ($state) {
                $state.loaded()
                for (var i = 0; i < 5; i++) {
                    this.bicycles.push({
                        bikeID: "1231223123",
                        dockedAt: "Hamilton"
                    })
                }
                $state.complete()
                return
                let This = this
                this.RhodeITSmartContract.methods.getRegisteredBicycleKeys().call({
                    gas: 8000000
                }).then((keys, err) => {
                    if (!err) {
                        console.log(keys)
                        keys.forEach((key) => {
                            This.RhodeITSmartContract.methods.getBicycle(key).call({
                                gas: 8000000
                            }).then((dockedAt, err) => {
                                if (!err) {
                                    This.bicycles.push({
                                        bikeID: key,
                                        dockedAt: dockedAt
                                    })
                                }
                            })
                        })
                    }
                }).catch((err) => {
                    console.log(err)
                    This.error('Something went wrong whilst loading registered users')
                })
            },
            deRegisterBicycle: async function (bicycle) {
                console.log(`removibg bicycle ${bicycle}`)
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