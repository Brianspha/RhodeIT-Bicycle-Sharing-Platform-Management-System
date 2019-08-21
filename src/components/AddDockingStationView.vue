<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>
                <v-dialog v-model="dialog" persistent max-width="100%" align-start justify-center row fill-height>
                    <v-card v-if="dialog">
                        <v-card-title>
                            <span class="headline">Venue on Campus</span>
                        </v-card-title>
                        <!-- Map -->
                        <googlemaps-map ref="map" class="map" :center.sync="center" :zoom.sync="zoom">
                            <!-- Marker -->
                            <googlemaps-marker :title="selectedVenue.name" :draggable="false"
                                :position="selectedVenue.position" />
                        </googlemaps-map>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="#7EC0EE" flat="flat" @click="dialog = false">Close</v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
                <v-flex>
                    <v-card class="elevation-12">
                        <v-toolbar color="#7EC0EE" dark>
                            <v-toolbar-title>Docking Stations</v-toolbar-title>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                        <v-list two-line v-if="venueLocations.length>0">
                            <template v-for="(venue, index) in venueLocations">
                                <v-list-tile :key="index+new Date().getTime()" avatar ripple>
                                    <v-list-tile-content>
                                        <v-list-tile-title>Name: {{ (venue.name) }}
                                        </v-list-tile-title>
                                        <v-list-tile-title>Registered: {{ (venue.isRegistered) }}
                                        </v-list-tile-title>
                                        <v-list-tile-sub-title>Description: {{ venue.description }}
                                        </v-list-tile-sub-title>
                                    </v-list-tile-content>
                                    <v-btn icon x-smal ripple>
                                        <v-icon color="grey lighten-1"
                                            @click="selectedVenue=venue; registerDockingStation()">check_circle_outline
                                        </v-icon>
                                    </v-btn>
                                    <v-btn icon x-smal ripple>
                                        <v-icon color="grey lighten-1"
                                            @click="selectedVenue=venue;removeDockingStation()">
                                            remove_circle_outline</v-icon>
                                    </v-btn>
                                </v-list-tile>
                                <v-divider v-if="index + 1 < venueLocations.length" :key="index"></v-divider>
                            </template>
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
    import {
        async
    } from 'q';

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
                Web3: null
            }
        },
        watch: {
            venueLocations: function () {
                let This = this
                //console.log('This.Rhode', This.RhodeITSmartContract)
                if (This.RhodeITSmartContract) {
                    This.RhodeITSmartContract.methods.getRegisteredDockingStationKeys().call({
                        gas: 8000000
                    }).then((keys, err) => {
                        if (err) {
                            This.error("Something went wrong: ", err)
                            //console.log("err: ", err)
                        } else {
                            if (keys.length > 0) {
                                keys.forEach(key => {
                                    This.RhodeITSmartContract.methods.getDockingStation(key).call({
                                        gas: 8000000
                                    }).then((station, err) => {
                                        if (err) {
                                            This.error("Something went wrong: ", err)
                                            //console.log("err: ", err)
                                        } else {
                                            var name = station.name
                                            var lat = station.latitude
                                            var long = station.longitude
                                            This.venueLocations = This.venueLocations.map((
                                                venue) => {
                                                //console.log(venue.name)
                                               // console.log("!keys.includes(veneu.name)",!keys.includes(venue.name))
                                                if (venue.name === name) {
                                                    venue.isRegistered = "Yes"
                                                } else if(!keys.includes(venue.name)) {
                                                    venue.isRegistered = "No"
                                                }
                                                return venue
                                            })
                                        }
                                    }).catch((err) => {
                                        //console.log(err)
                                    })
                                });
                            } else {
                                This.venueLocations.map((venue) => {
                                    venue.isRegistered = "No"
                                    return venue
                                })
                            }
                        }
                    }).catch((err) => {
                        This.error("Something went wrong: ", err)
                        //console.log("err: ", err)
                    })
                }
            },
            RhodeITSmartContract: async function () {
                let This = this
                this.RhodeITSmartContract.methods.getRegisteredDockingStationKeys().call({
                    gas: 8000000
                }).then((keys, err) => {
                    if (err) {
                        This.error("Something went wrong: ", err)
                        //console.log("err: ", err)
                    } else {
                        if (keys.length > 0) {
                            console.log("Keys: ", keys)
                            keys.forEach(key => {
                                This.RhodeITSmartContract.methods.getDockingStation(key).call({
                                    gas: 8000000
                                }).then((station, err) => {
                                    if (err) {
                                        This.error("Something went wrong: ", err)
                                        //console.log("err: ", err)
                                    } else {
                                        var name = station.name
                                        var lat = station.latitude
                                        var long = station.longitude
                                        This.venueLocations = This.venueLocations.map((
                                            venue) => {
                                            if (venue.name === name) {
                                                venue.isRegistered = "Yes"
                                            }
                                            return venue
                                        })
                                    }
                                }).catch((err) => {
                                    //console.log(err)
                                })
                            });
                        } else {
                            this.venueLocations.map((venue) => {
                                venue.isRegistered = "No"
                                return venue
                            })
                        }
                    }
                }).catch((err) => {
                    this.error("Something went wrong: ", err)
                    //console.log("err: ", err)
                })
            }
        },
        mounted() {
            this.init()
        },
        methods: {
            init() {
                EmbarkJS.onReady((err) => {
                    //console.log(err)
                    this.RhodeITSmartContract = require('../../embarkArtifacts/contracts/RhodeIT')
                    this.Web3 = EmbarkJS
                    //console.log(this.RhodeITSmartContract)
                })
            },
            loadvenueLocations($state) {
                var venues = require('../json/venues.json')
                //console.log(venues)
                let This = this
                venues.forEach((venue)=> {
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
            },
            getVenueDetails(index) {
                //console.log(this.venueLocations[index])
                return this.venueLocations[index]
            },
            registerDockingStation: async function () {
                this.isLoading = true
                let This = this
                //console.log(this.selectedVenue)
                this.RhodeITSmartContract.methods.registerDockingStation(this.selectedVenue.name, this
                    .selectedVenue.position.lat.toString(), this.selectedVenue.position.lng.toString()).send({
                    gas: 8000000
                }).then((
                    receipt, err) => {
                    if (err) {
                        This.error("Something went wrong: ", err)
                        //console.log("err: ", err)
                    } else {
                        This.success("Successfully Registered Docking Station")
                    }
                    This.isLoading = false
                }).catch((err) => {
                    This.error("Something went wrong: ", err)
                    //console.log("err: ", err)
                    This.isLoading = false
                })
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
                    title: 'And i-oop...',
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