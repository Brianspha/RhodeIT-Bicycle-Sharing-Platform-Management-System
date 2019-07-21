<template>
  <v-app id="inspire">
    <v-container fluid align-start justify-start row fill-height>
      <v-layout align-start justify-start row fill-height>
        <v-flex>
          <v-card class="elevation-12">
            <v-toolbar dark color="#7E57C2">
              <v-toolbar-title>Mint New NFT Token</v-toolbar-title>
              <v-spacer></v-spacer>
              <v-tooltip right>
                <template>
                </template>
                <span></span>
              </v-tooltip>
            </v-toolbar>
            <v-card-text>
              <v-form v-model="valid" ref="form">
                <v-text-field v-model="name" :counter="100" :rules="nameRules" label="Name" required></v-text-field>
                <v-text-field v-model="level" :rules="levelRules" label="Level" type="number" required></v-text-field>
                <v-text-field name="login" label="NFT Value" type="number" v-model="value" :rules="valueRules">
                </v-text-field>
                <v-textarea name="input-7-1" label="NFT Description" auto-grow hint="Description of the Game Item"
                  v-model="description" :rules="descriptionRules">
                </v-textarea>
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="#7E57C2" @click="register()">Register</v-btn>
              <v-btn color="#7E57C2" :disabled="!valid" @click="mintToken()">Mint</v-btn>
              <v-btn color="#7E57C2" @click="reset()">
                Reset Form
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-flex>
      </v-layout>
      <loading :active.sync="isLoading" :can-cancel="false" :is-full-page="fullPage">

      </loading>
    </v-container>
  </v-app>
</template>
<script>
  import Loading from 'vue-loading-overlay';
  // Import stylesheet
  import 'vue-loading-overlay/dist/vue-loading.css';
  import Swal from 'sweetalert2'
export default {
    name:"Add Bicycle",
    data(){
        return{
            disabled:false
        }
    }
}

</script>