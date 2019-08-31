<template>
    <v-app id="inspire">
        <v-container align-start justify-start row fill-height>
            <v-layout>
                <v-flex>
                    <v-card>
                        <v-toolbar color="#7EC0EE" dark>
                            <v-toolbar-title>Update Contract</v-toolbar-title>
                            <v-spacer></v-spacer>
                        </v-toolbar>
                        <v-form ref="form" v-model="valid" lazy-validation>
                            <v-text-field v-model="address" :counter="42" :rules="addressRules" label="Address " required
                                hint="e.g. 0xe9CeDE851acf8e63bb359bd4b505b47b8777C419"></v-text-field>
                            <v-btn color="#7EC0EE" @click="resetValidation">
                                Update
                            </v-btn>
                        </v-form>
                    </v-card>
                </v-flex>
            </v-layout>
        </v-container>
    </v-app>
</template>
<script>
    export default {
        data: () => ({
            valid: true,
            address: '',
            addressRules: [
                v => !!v || 'Name is required',
                v => (v && v.length === 42 && web3.utils.isAddress(v)) ||
                'Contract address must be 42 characters long and must be valid',
            ]
        }),

        methods: {
            validate() {
                if (this.$refs.form.validate()) {
                    this.snackbar = true
                }
            },
            reset() {
                this.$refs.form.reset()
            },
            resetValidation() {
                this.$refs.form.resetValidation()
            },
        },
    }
</script>