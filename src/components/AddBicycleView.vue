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
                                <v-select :options="dockingStations"></v-select>
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
        </v-container>
    </v-app>
</template>
<script>
    import crypto from 'crypto'
    export default {
        data: () => ({
            valid: true,
            dockingStation: '',
            dockingStationRule: [
                v => !!v || 'Docking station name is required',
                v => (v && v.length > 0) ||
                'Docking Station Name must be greater than 0 characters',
            ],
            bikeId: crypto.randomBytes(16).toString("hex"),
            dockingStations: [],
            RhodeITConract: {}
        }),
        mounted() {
            this.init()
            this.getDockingStations()
        },
        methods: {
            init() {
                this.RhodeITConract = require("../../embarkArtifacts/contracts/RhodeIT")
            },
            validate() {
                if (this.$refs.form.validate()) {
                    this.snackbar = true
                    alert("valid")
                    this.registerBicycle()
                } else {
                    alert("not valid")
                }

            },
            registerBicycle: async function () {
                console.log("adding new bicycle")
            },
            getDockingStations: function async () {
                var venues = require('../json/venues.json')
                venues.forEach((venue) => {
                    this.dockingStations.push(
                        venue.properties.name
                    )
                })
            }
        }
    }
</script>