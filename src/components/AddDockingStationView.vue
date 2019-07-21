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
                                        <v-list-tile-sub-title>Description: {{ venue.description }}
                                        </v-list-tile-sub-title>
                                    </v-list-tile-content>
                                    <v-btn icon x-smal ripple><v-icon color="grey lighten-1">check_circle_outline</v-icon></v-btn>
                                    <v-btn icon x-smal ripple><v-icon color="grey lighten-1">remove_circle_outline</v-icon></v-btn>
                                 </v-list-tile>
                                 
                                <v-divider v-if="index + 1 < venueLocations.length" :key="index"></v-divider>
                            </template>
                        </v-list>
                        <InfiniteLoading @infinite="loadvenueLocations" spinner="waveDots"></InfiniteLoading>
                    </v-card>
                </v-flex>
            </v-layout>
        </v-container>
    </v-app>
</template>
<script>
    import 'vue-loading-overlay/dist/vue-loading.css';
    import InfiniteLoading from 'vue-infinite-loading';
    import {
        MapElement
    } from 'vue-googlemaps'
    import {
        mapActions
    } from 'vuex'

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
            InfiniteLoading
        },
        data() {
            return {
                selectedVenue: null,
                RhodeITSmartContract: null,
                center: {
                    lat: 26.520642,
                    lng: -33.311836
                },
                venueLocations: [],
                dialog: null,
                zoom: 8
            }
        },
        mounted() {
            this.init()
        },
        methods: {

            init() {
                load('AIzaSyCjMY_194mgeHLsyhlPre7kZ-UVXHCCt0o')
            },
            ...mapActions('layout', [
                'toggleSideNav',
            ]),
            loadvenueLocations($state) {
                var venues = require('../json/venues.json')
                console.log(venues)

                for (var i = 0; i < venues.length; i++) {
                    this.venueLocations.push({
                        name: venues[i].properties.name,
                        description: venues[i].properties.desc,
                        position: {
                            lat: venues[i].geometry.coordinates[0],
                            lng: venues[i].geometry.coordinates[1]
                        }
                    })
                    $state.loaded()
                }
                $state.complete()
            },
            getVenueDetails(index) {
                console.log(this.venueLocations[index])
                return this.venueLocations[index]
            },
            showVenueOnMap() {}
        },
        mixins: [
            // You need to use this mixin
            MapElement,
        ],
        // When Google Maps is ready
        googleMapsReady() {
            if (!this.$_map || this.$_marker) return
            console.log("here")
            const options = Object.assign({}, this.$props)
            options.map = this.$_map

            // Create Google Maps objects
            this.$_marker = new window.google.maps.Marker(options)
            // Bind the Vue props
            this.bindProps(this.$_marker, boundProps)
            // Emit the events from Google Maps
            this.redirectEvents(this.$_marker, redirectedEvents)
        },
        beforeDestroy() {
            // Teardown
            if (this.$_marker) {
                this.$_marker.setMap(null)
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