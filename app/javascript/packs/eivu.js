import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'
import VuePlyr from 'vue-plyr'
import axios from 'axios';
import plyr from './components/plyr.vue'
import "babel-core/register"
import 'babel-polyfill'

Vue.use(VuePlyr)
Vue.use(Vuex)


Vue.prototype.$http = axios;
// Vue.use(axios) doesn't work i don't know why

Vue.component('cloud-file', {
  props: ['file'],
  template:
    `<div class="row">
      <div class="col-xs-1">{{ file.release_pos && file.release_pos.pad() }}</div>
      <div class="col-xs-4">{{ file.name }}</div>
      <div class="col-xs-7">
        <span v-if="isPlaying">
          <a href="javascript:void(0)">
            <i class="fas fa-pause" @click="pause"></i>
          </a>
        </span>
        <span v-else>
          <a href="javascript:void(0)">
            <i class="fas fa-play" @click="play"></i>
          </a>
        </span>
        <i class="fas fa-plus"></i>
        <a v-bind:href="file.url" target="_blank">
          <i class="fas fa-external-link-alt"></i>
        </a>
      </div>
    </div>`,
  computed: {
    isPlaying: function() {
      return this.$store.getters.isPlaying && this.activeTrack;
    },
    activeTrack: function() {
      return this.$store.getters.current_track_vue_id == this.file.vue_id
    }
  },
  methods: {
    play() {
      if (this.activeTrack)
        this.$store.commit("togglePlay");
      else
        this.$store.commit("play_file", this.file);
    }
  }
});




const store = new Vuex.Store({
  state: {
    current_track: null,
    playing: null,
    plyr: null
  },
  getters: {
    current_track: state => {
      return state.current_track;
    },
    current_track_vue_id: state => {
      return state.current_track && state.current_track.vue_id;
    },
    isPlaying: state => {
      return state.playing;
    }
  },
  mutations: {
    play_file (state, file) {
      state.current_track = file;
      state.plyr.player.source = {
        type: 'audio',
        title: state.current_track.name,
        sources: [
          {
            src: state.current_track.url,
            type: 'audio/mp3',
          },
        ],
      };
      state.plyr.player.play();
    },
    pause (state) {
      state.plyr.player.pause();
    },
    togglePlay (state) {
      state.plyr.player.togglePlay();
    },
    setPlayState(state, boolean) {
      state.playing = boolean;
    },
    setPlyr (state, plyr) {
      state.plyr = plyr
    }
  },
})



Vue.component('tree-node', {
  props: ['node'],
  data() {
    return { showChildren: false, dataLoaded: false, children: [] }
  },
  template: 
    `<li v-bind:id="node.id" v-bind:class="node.entry_type">
        <span v-if="node.entry_type == 'grouping'">
          <div v-bind:class="node.klass" v-bind:type="node.entry_type" @click="toggleChildren">{{ node.name }}</div>
        </span>
        <span v-else-if="node.entry_type == 'file'">
          <cloud-file v-bind:file="node"></cloud-file>
        </span>
        <span v-else>
          <div>{{ node.name }}</div>
        </span>
       
      <ul v-if="node.children && showChildren">
        <tree-node v-for="child in children" v-bind:node="child" :key="child.vue_id">
        </tree-node>
      </ul>
    </li>`,
  methods: {
    toggleChildren() {
      this.fetchData()
      this.showChildren = !this.showChildren;
    },
    fetchData() {
      // create a child to stub a loading message
      this.children = [{id: (new Date().getTime() * -1), name:"Loading...." }]
      this.$http.get(`/api/v1/folders/${this.node.id}`)
        .then(
          response => {

          this.children = response.data.data.children
          this.dataLoaded = true;

          }
        )

          // console.log(response.data.data.children)
        .catch((error) => {
          console.log(error);
        });

    }
  }
})

document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    el: '#app',
    store,
    components: { plyr },
    data: {
      message: 'Hello Vue!',
      treeData: [{id: (new Date().getTime() * -1), name:"Loading...." }]
    },
    mounted () {
      this.$http
        .get('/api/v1/folders')
        .then(
          response => (
          this.treeData = response.data.data))
    }
  })
})