<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>
                <v-flex>
                    <v-card>
                        <v-toolbar color="#7EC0EE" dark>
                            <v-toolbar-title>Register Bicycle</v-toolbar-title>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                        <v-form ref="form" v-model="valid" lazy-validation>
                            <div>
                                <h3>Docked At</h3>
                                <v-select :options="dockingStations" v-model="dockingStation"></v-select>
                            </div>
                            <v-text-field v-model="bikeId" label="BikeID " disabled>
                            </v-text-field>
                            <v-btn color="#7EC0EE" @click="validate">
                                Register
                            </v-btn>
                        </v-form>
                    </v-card>
                </v-flex>
            </v-layout>
            <loading :active.sync="isLoading" :can-cancel="false" :is-full-page="true" />
        </v-container>
    </v-app>
</template>
<script>
    import crypto from 'crypto'
    import InfiniteLoading from 'vue-infinite-loading';
    import Swal from 'sweetalert2'
    import Loading from 'vue-loading-overlay';
    import 'vue-loading-overlay/dist/vue-loading.css';
    export default {
        components: {
            Loading
        },
        data: () => ({
            isLoading: false,
            valid: true,
            dockingStation: '',
            dockingStationRule: [
                v => !!v || 'Docking station name is required',
                v => (v && v.length > 0) ||
                'Docking Station Name must be greater than 0 characters',
            ],
            bikeId: crypto.randomBytes(16).toString("hex"),
            dockingStations: [],
            rhodeITContract: {}
        }),
        mounted() {
            this.init()
            this.getDockingStations()
        },
        methods: {
            init() {
                this.rhodeITContract = require("../../embarkArtifacts/contracts/RhodeIT")
            },
            validate() {
                console.log('bicycle docked At: ', this.dockingStation)
                if (this.$refs.form.validate() && this.dockingStation !== '') {
                    this.snackbar = true
                    this.isLoading = true;
                    this.registerBicycle()
                } else {
                    this.error("Invalid bicycle details!!")
                }
            },
            registerBicycle: async function () {
                let This = this
                this.rhodeITContract.methods.registerNewBicycle(this.bikeId, this.dockingStation).send({
                    gas: 8000000
                }).then((receipt, err) => {
                    if (!err) {
                        This.success("Succesfully registered new bicycle")
                    }
                    This.isLoading = false
                    This.bikeId=crypto.randomBytes(16).toString("hex")
                }).catch((err) => {
                    console.log("Error whilst adding new bicycle!!")
                    console.log(err)
                    This.error("Error whilst adding new bicycle!!")
                    This.isLoading = false
                    This.bikeId=crypto.randomBytes(16).toString("hex")
                })
            },
            getDockingStations: function async () {
                var venues = require('../json/venues.json')
                this.isLoading = true
                let This = this
                this.rhodeITContract.methods.getRegisteredDockingStationKeys().call({
                    gas: 8000000
                }).then((keys, err) => {
                    if (!err && keys.length > 0) {
                        keys.forEach((key) => {
                            venues.forEach((venue) => {
                                console.log("venue: ",venue.properties.name)
                                console.log("key: ",key)
                                if (key === venue.properties.name) {
                                    This.dockingStations.push(
                                        venue.properties.name
                                    )
                                }
                            })
                        })
                        This.isLoading = false
                    }
                }).catch((err) => {
                    console.log("error getting registered docking stations")
                    console.log(err)
                    this.isLoading = false
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