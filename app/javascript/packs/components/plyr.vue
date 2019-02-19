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
    computed: {
      playing () { return 1;
        //this.$refs.plyr.player.playing 
      }
    },
    mounted() {
      this.player = this.$refs.plyr.player;
      this.player.on('play', () => alert(1));
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