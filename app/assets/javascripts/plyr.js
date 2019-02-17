


document.addEventListener('DOMContentLoaded', function(event) {
  // Change "{}" to your options:
  // https://github.com/sampotts/plyr/#options
  const player = new Plyr('audio', {});

  // Expose player so it can be used from the console
  window.player = player;
});

// //Video information
// document.addEventListener('DOMContentLoaded', function(event) {
//   // This is the bare minimum JavaScript. You can opt to pass no arguments to setup.
//   // const player = new Plyr('#plyr_container');
//   const player = new Plyr(document.getElementById('plyr_container'));
  
//   // Expose
//   window.player = player;

//   // // Bind event listener
//   // function on(selector, type, callback) {
//   //   document.querySelector(selector).addEventListener(type, callback, false);
//   // }

//   // // Play
//   // on('.js-play', 'click', () => { 
//   //   player.play();
//   // });

//   // // Pause
//   // on('.js-pause', 'click', () => { 
//   //   player.pause();
//   // });

//   // // Stop
//   // on('.js-stop', 'click', () => { 
//   //   player.stop();
//   // });

//   // // Rewind
//   // on('.js-rewind', 'click', () => { 
//   //   player.rewind();
//   // });

//   // // Forward
//   // on('.js-forward', 'click', () => { 
//   //   player.forward();
//   // });
// });