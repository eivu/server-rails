import Vue from 'vue/dist/vue.esm'

document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
    },
    // mounted: {
    //   axios
    //     .get('https://api.coindesk.com/v1/bpi/currentprice.json')
    //     .then(response => (this.info = response))
    // }
  })
})