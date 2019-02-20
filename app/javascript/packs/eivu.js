import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'
import VuePlyr from 'vue-plyr'
import axios from 'axios';
import plyr from './components/plyr.vue'
import TreeNode from './components/tree-node.vue'
import "babel-core/register"
import 'babel-polyfill'

Vue.use(VuePlyr)
Vue.use(Vuex)


Vue.prototype.$http = axios;
// Vue.use(axios) doesn't work i don't know why



const store = new Vuex.Store({
  state: {
    current_track: null,
    currentTrackObject: null,
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
    },
    currentTrackObject: state => {
      return state.currentTrackObject;
    },
    nextAutoTrackObject: (state, getters) => {
      // declare variables to holdl current and next pos
      var pos;
      var nextPos;
      var nextNodeObject;

      if (state.currentTrackObject) {
        // find the position for the current track
        pos = state.currentTrackObject.$parent.$parent.$children.findIndex(function(element) {
          return element.node.vue_id == getters.current_track_vue_id
        });

        // return the next track
        nextPos = pos + 1
        // go up the tree to the grouping ($parent.$parent) to the next node
        nextNodeObject = state.currentTrackObject.$parent.$parent.$children[nextPos]
        // return the cloudfile component of the next node
        return nextNodeObject && nextNodeObject.$children[0];
      }
    }
  },
  mutations: {
    playCloudFile (state, object) {
      state.currentTrackObject = object
      state.current_track = object.file;
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
    clearCurrentTrackObject (state) {
      state.currentTrackObject = null;
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


document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    el: '#app',
    store,
    components: { plyr, TreeNode},
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