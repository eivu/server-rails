<template>
  <div class="row">
    <div class="col-xs-1">{{ file.release_pos && file.release_pos.pad() }}</div>
    <div class="col-xs-4">{{ file.name }}</div>
    <div class="col-xs-7">
      <span v-if="isPlaying">
        <a href="javascript:void(0)">
          <i class="fas fa-pause" @click="play"></i>
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
  </div>
</template>

<script>
  export default {
    name: "CloudFile",
    props: ['file'],
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
        else {
          this.$store.commit("playCloudFile", this);
        }
      }
    }
  };
</script>