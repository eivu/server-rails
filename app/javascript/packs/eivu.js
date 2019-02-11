import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
import "babel-core/register"
import 'babel-polyfill'

Vue.prototype.$http = axios;
// Vue.use(axios) doesn't work i don't know why

Vue.component('tree-node', {
  props: ['node'],
  data() {
    return { showChildren: false, dataLoaded: false, children: [] }
  },
  template: 
    `<li v-bind:id="node.id">
      <div v-bind:class="node.klass" @click="toggleChildren">{{ node.name }}</div>
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
      this.children = [{id: (new Date().getTime() * -1), name:"Loading...."}]
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

      // debugger;
      // await this.$http
      //   .get(`/api/v1/folders/${this.node.id}`)
      //   .then(
      //     response => (
      //     this.children = response.data.data.children))
      //     console.log
      //     (this.children)
      //   .catch((error) => {
      //     console.log(error);
      //   });

    }
  }
})

document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!',
      treeData: [{id: (new Date().getTime() * -1), name:"Loading...."}]
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


// <tree-node
//       v-for="node in treeData"
//       v-bind:node="node"
//     ></tree-node>
//   </ul>