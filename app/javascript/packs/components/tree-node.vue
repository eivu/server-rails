<template>
  <li v-bind:id="node.id" v-bind:class="node.entry_type">
    <span v-if="node.entry_type == 'grouping'">
      <div v-bind:class="node.klass" v-bind:type="node.entry_type" @click="toggleChildren">{{ node.name }}</div>
    </span>
    <span v-else-if="node.entry_type == 'file'">
      <CloudFile v-bind:file="node"></CloudFile>
    </span>
    <span v-else>
      <div>{{ node.name }}</div>
    </span>
   
    <ul v-if="node.children && showChildren">
      <TreeNode v-for="child in children" v-bind:node="child" :key="child.vue_id">
      </TreeNode>
    </ul>
  </li>
</template>

<script>
  import CloudFile from './cloud-file.vue';

  export default {
    name: "TreeNode",
    props: ['node'],
    components: { CloudFile },
    data() {
      return { showChildren: false, dataLoaded: false, children: [] }
    },
    computed: {
      // testing: function() {
      //   return  this.$store.getters.nextAutoTrackObject && this.$store.getters.nextAutoTrackObject.node.name;
      // },
    },
    methods: {
      test () {
        this.$store.getters.nextAutoTrackObject;
      },
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
  };
</script>