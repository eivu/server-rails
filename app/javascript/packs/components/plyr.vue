<template>
  <vue-plyr ref="plyr">
    <audio>
      <source src="http://eivu.s3.amazonaws.com/welcome.mp3" type="audio/mp3"/>
    </audio>
  </vue-plyr>
</template>


<script>
  export default {
    name: "plyr",
    data() {
      return {
        duration: null,
      };
    },
    // computed: {
    // },
    mounted() {
      this.player = this.$refs.plyr.player;
      window.player = this.player;
      this.player.on('play', () => this.$store.commit("setPlayState", true));
      this.player.on('pause', () => this.$store.commit("setPlayState", false));
      this.player.on('ended', () => {
        var nextTrackObject = this.$store.getters.nextAutoTrackObject;
debugger
        // if currentTrackObject is the same as nextTrackObject clear it out
        if (nextTrackObject === undefined)
          this.$store.commit("clearCurrentTrackObject");
        else // otherwise play the next found track
          nextTrackObject && this.$store.commit("playCloudFile", nextTrackObject)
      })
      this.$store.commit("setPlyr", this.$refs.plyr);
    },
    // methods: {
    //   videoTimeUpdated: function(event) {
    //     this.duration = this.player.currentTime;
    //   }
  };
</script>

<!-- 
<script>
  name: 'Component',
  mounted () {
    console.log(this.player)
  },
  computed: {
    player () { return this.$refs.plyr.player }
  }
</script>
 -->