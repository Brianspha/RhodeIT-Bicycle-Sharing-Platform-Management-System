<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>
                <v-flex>
                    <v-card>
                        <v-toolbar color="#7EC0EE" dark>
                            <v-toolbar-title>Docking Stations</v-toolbar-title>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                        <v-list two-line v-if="venueLocations.length>0">
                            <v-card v-for="(venue, index) in venueLocations" :ripple="{ center: true }"
                                :key="new Date().getMilliseconds()+index">
                                <v-list-tile :key="index+new Date().getTime()" avatar>
                                    <v-list-tile-content>
                                        <v-list-tile-title>Name: {{ (venue.name) }}
                                        </v-list-tile-title>
                                        <v-list-tile-title>Registered: {{ (venue.isRegistered) }}
                                        </v-list-tile-title>
                                        <v-list-tile-sub-title>Description: {{ venue.description }}
                                        </v-list-tile-sub-title>
                                    </v-list-tile-content>
                                    <v-tooltip top>
                                        <template v-slot:activator="{ on }">
                                            <v-btn icon x-smal :ripple="{ center: true }">
                                                <v-icon color="grey lighten-1"
                                                    @click="selectedVenue=venue; registerDockingStation()" v-on="on">
                                                    check_circle_outline
                                                </v-icon>
                                            </v-btn>
                                        </template>
                                        <span>Register Docking Station</span>
                                    </v-tooltip>
                                    <v-tooltip top>
                                        <template v-slot:activator="{ on }">
                                            <v-btn icon x-smal :ripple="{ center: true }">
                                                <v-icon color="grey lighten-1"
                                                    @click="selectedVenue=venue;removeDockingStation()" v-on="on">
                                                    remove_circle_outline</v-icon>
                                            </v-btn>
                                        </template>
                                        <span>Remove Docking Station</span>
                                    </v-tooltip>

                                </v-list-tile>
                                <v-divider v-if="index + 1 < venueLocations.length" :key="index"></v-divider>
                            </v-card>
                        </v-list>
                        <InfiniteLoading @infinite="loadvenueLocations" spinner="waveDots"></InfiniteLoading>
                        <loading :active.sync="isLoading" :can-cancel="false" :is-full-page="fullPage">
                        </loading>
                    </v-card>
                </v-flex>
            </v-layout>
        </v-container>
    </v-app>
</template>
<script>
    import each from 'each'
    import Loading from 'vue-loading-overlay';
    import 'vue-loading-overlay/dist/vue-loading.css';
    import InfiniteLoading from 'vue-infinite-loading';
    import {
        MapElement
    } from 'vue-googlemaps'
    import {
        mapActions
    } from 'vuex'
    import EmbarkJS from '../../embarkArtifacts/embarkjs';
    import Swal from 'sweetalert2'

    // Those Vue props will update automatically
    // (Two-way binding with .sync modifier)
    const boundProps = [
        'animation',
        'clickable',
        'cursor',
        'draggable',
        // ...
    ]

    // Events from Google Maps emitted as Vue events
    const redirectedEvents = [
        'click',
        'rightclick',
        'dblclick',
        'drag',
        // ...
    ]

    export default {
        components: {
            InfiniteLoading,
            Loading
        },
        data() {
            return {
                remove: false,
                add: false,
                fullPage: true,
                isLoading: false,
                selectedVenue: null,
                RhodeITSmartContract: null,
                center: {
                    lat: 26.520642,
                    lng: -33.311836
                },
                venueLocations: [],
                dialog: null,
                zoom: 8,
                Web3: null,
                loaded: false
            }
        },
        watch: {
            RhodeITSmartContract: async function () {

            }
        },
        mounted() {
            this.init()
        },
        methods: {
            init() {
                EmbarkJS.onReady((err) => {
                    if(err){
                    this.error('Seems like you dont have metamask installed!')
                    }
                    else{
                    this.loadContract()
                    this.Web3 = EmbarkJS
                    }
                })
            },
            loadContract() {
                this.RhodeITSmartContract = require('../../embarkArtifacts/contracts/RhodeIT')
                console.log(this.RhodeITSmartContract)
                this.loadVenuesFromSmartContract()
            },
            loadVenuesFromSmartContract: async function () {
                let This = this
                this.isLoading = false
                this.RhodeITSmartContract.methods.getRegisteredDockingStationKeys().call({
                    gas: 8000000
                }).then((keys, err) => {
                    if (!keys) {
                        this.error("Something went wrong: ", err)
                        //console.log("err: ", err)
                    } else {
                        if (keys.length > 0) {
                            console.log("Keys: ", keys)
                            keys.forEach(async function (key) {
                                var station = await This.RhodeITSmartContract.methods
                                    .getDockingStation(key)
                                    .call({
                                        gas: 8000000
                                    })
                                if (!station) {
                                    This.error("Something went wrong: ", err)
                                    //console.log("err: ", err)
                                } else {
                                    var name = station.name
                                    var lat = station.latitude
                                    var long = station.longitude
                                    var tempLocations = []
                                    This.venueLocations.map((venue) => {
                                        if (venue.name === name) {
                                            venue.isRegistered = "Yes"
                                        } else if (venue.isRegistered !== "Yes") {
                                            venue.isRegistered = "No"
                                        }
                                        return venue
                                    })
                                }
                            });
                        } else {
                            this.venueLocations.map((venue) => {
                                venue.isRegistered = "No"
                                return venue
                            })
                        }
                    }
                }).catch((err) => {
                    console.log(err)
                    this.error("Something went wrong: ", err)
                })

            },
            loadvenueLocations($state) {
                var venues = require('../json/venues.json')
                this.venueLocations = []
                //console.log(venues)
                let This = this
                venues.forEach((venue) => {
                    this.venueLocations.push({
                        name: venue.properties.name,
                        description: venue.properties.desc,
                        position: {
                            lat: venue.geometry.coordinates[1],
                            lng: venue.geometry.coordinates[0]
                        },
                        isRegistered: 'Querying Contract...'
                    })
                    //console.log(This.RhodeITSmartContract)
                    $state.loaded()
                })
                $state.complete()
                this.loaded = true
            },
            getVenueDetails(index) {
                //console.log(this.venueLocations[index])
                return this.venueLocations[index]
            },
            registerDockingStation: async function () {
                this.isLoading = true
                let This = this
                //console.log(this.selectedVenue)
                var receipt = await this.RhodeITSmartContract.methods.registerDockingStation(this.selectedVenue
                    .name, this
                    .selectedVenue.position.lat.toString(), this.selectedVenue.position.lng.toString()).send({
                    gas: 8000000
                })

                if (!receipt) {
                    This.error("Something went wrong: ", err)
                    //console.log("err: ", err)
                } else {
                    This.success("Successfully Registered Docking Station")
                    This.loadContract();
                }
                This.isLoading = false
            },
            removeDockingStation: async function () {
                this.error("Seems the function hasnt been implemented as yet!!")
            },
            showVenueOnMap() {},
            triggerUpdate() {
                this.venueLocations = require('../json/venues.json')
            },
            errorWithFooter(footerMessage, text) {
                Swal.fire({
                    type: 'error',
                    title: 'OH Noo',
                    text: text,
                    footer: footerMessage
                })
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
    googlemaps-map {
        width: 100%;
        height: 100%;
        display: block;
    }
</style>