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
        // player: null
      };
    },
    computed: {
      player () { return this.$refs.plyr.player }
    },

    // components: {},
    mounted() {
      this.player = this.$refs.plyr.player;
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