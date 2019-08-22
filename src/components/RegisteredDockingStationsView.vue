<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>

                <v-flex>
                    <v-toolbar color="#7EC0EE" dark>
                        <v-toolbar-title>Docking Stations</v-toolbar-title>
                        <v-spacer></v-spacer>
                    </v-toolbar>

                    <v-map :zoom=10 :center="center">
                        <v-icondefault></v-icondefault>
                        <v-tilelayer url="http://{s}.tile.osm.org/{z}/{x}/{y}.png"></v-tilelayer>
                        <v-marker-cluster :options="clusterOptions" @clusterclick="click()">
                            <v-marker v-for="venue in venueLocations" :key="venue.name+venue.position"
                                :lat-lng="venue.position" :icon="icon">
                                <v-popup
                                    :content="venue.description +'<br><b>IsDockingStation:</b>' +venue.isRegistered">
                                </v-popup>
                            </v-marker>
                        </v-marker-cluster>
                    </v-map>
                </v-flex>
            </v-layout>
        </v-container>
    </v-app>
</template>

<script>
    import EmbarkJS from '../../embarkArtifacts/embarkjs';
    import {
        LMap,
        LTileLayer,
        LMarker,
        LIconDefault,
        LPopup
    } from 'vue2-leaflet';
    import * as Vue2Leaflet from 'vue2-leaflet'
    import Vue2LeafletMarkerCluster from 'vue2-leaflet-markercluster'
    import {
        latLng,
        Icon,
        icon
    } from 'leaflet'
    import iconUrl from 'leaflet/dist/images/marker-icon.png'
    import shadowUrl from 'leaflet/dist/images/marker-shadow.png'
    export default {
        components: {
            'v-map': Vue2Leaflet.LMap,
            'v-tilelayer': Vue2Leaflet.LTileLayer,
            'v-icondefault': Vue2Leaflet.LIconDefault,
            'v-marker': Vue2Leaflet.LMarker,
            'v-popup': Vue2Leaflet.LPopup,
            'v-marker-cluster': Vue2LeafletMarkerCluster,
            'v-icondefault': Vue2Leaflet.LIconDefault,
            'v-marker': Vue2Leaflet.LMarker,
            'v-popup': Vue2Leaflet.LPopup,
        },
        data() {
            return {
                url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
                attribution: '&copy; <a href=" http://osm.org/copyright">OpenStreetMap </a> contributors',
                map: null,
                center: L.latLng(-33.311836, 26.520642),
                zoom: 18,
                maxBoundsViscosity: 1.0,
                bounds: L.latLngBounds(L.latLng(-33.3109, 26.5241), L.latLng(-33.3186, 26.518276)),
                venueLocations: [],
                layers: [L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
                    maxZoom: 18,
                    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors, Points &copy 2012 LINZ'
                })],
                icon: icon(Object.assign({}, Icon.Default.prototype.options, {
                    iconUrl,
                    shadowUrl
                })),
                clusterOptions: {},
                RhodeITContract: null
            }
        },
        watch: {
            map: function () {
                this.$forceUpdate()
            }
        },
        mounted() {
            this.initMap();
            setTimeout(() => {
                console.log('done')
                this.$nextTick(() => {
                    this.clusterOptions = {
                        disableClusteringAtZoom: 11
                    }
                });
            }, 5000);
        },
        beforeMount() {
            var venues = require('../json/venues.json')
            venues.forEach((venue) => {
                this.venueLocations.push({
                    name: venue.properties.name,
                    description: "<b>Name:</b> " + (venue.properties.name !== "" ? venue.properties
                            .name :
                            "Campus Location") + "\n<br><b>Description:</b> " +
                        (venue.properties
                            .desc !== "" ? venue.properties
                            .desc : "No Description found!!"),
                    position: latLng(
                        venue.geometry.coordinates[1], venue.geometry.coordinates[0]
                    ),
                    isRegistered: "Querying Contract..."
                })

            })
        },
        methods: {
            initMap() {
                let This = this
                EmbarkJS.onReady((err) => {
                    console.log("error from connection: ", err)
                    this.RhodeITContract = require('../../embarkArtifacts/contracts/RhodeIT')
                    this.RhodeITContract.methods.getRegisteredDockingStationKeys().call({
                        gas: 8000000
                    }).then((keys, err) => {

                        if (keys.length > 0) {
                            keys.map((key) => {
                                this.venueLocations.map((venue) => {
                                    if (key === venue.name) {
                                        venue.isRegistered = "Yes"
                                    } else if(venue.isRegistered !== "Yes") {
                                        venue.isRegistered = "No"
                                    }
                                    return venue
                                })
                            })
                        } else {
                            This.venueLocations.map((venue) => {
                                venue.isRegistered = "No"
                                return venue
                            })
                        }
                    })

                })


                // this.$refs.map.addLayer(markerClusters)
            },
        }
    }
</script>

<style scoped>
    @import "~leaflet/dist/leaflet.css";
    @import "~leaflet.markercluster/dist/MarkerCluster.css";
    @import "~leaflet.markercluster/dist/MarkerCluster.Default.css";

    #map {
        height: 100%;
    }
</style>