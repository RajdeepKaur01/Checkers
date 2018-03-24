// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import socket from "./socket";
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function form_init() {
//  let channel = socket.channel("games:demo", {});
  // channel.join()
  //        .receive("ok", resp => { console.log("Joined successfully", resp) })
  //        .receive("error", resp => { console.log("Unable to join", resp) });

  $('#nameLink').click(() => {
    let xx = $('#game-input').val();
    document.getElementById("nameLink").href="/game/" + xx;

  //  channel.push("double", { xx: xx }).receive("doubled", msg => {
  //    $('#game-output').text(msg.yy);
//    });
  //  document.getElementById("nameLink").innerHTML="/demo/" + xx;
  });
}

import run_demo from "./checkers";

function init() {
  let root = document.getElementById('root');
  if(root){
    let channel = socket.channel("games:" + document.getElementById("player").innerHTML,  window.userName);
// var nodes= document.getElementsByTagName("li");
// let players=[];
//
// for(var i=0;i<nodes.length;i++){
//   players.push(nodes.item(i).innerHTML);
//   console.log(players[i]);
// }

      run_demo(root, channel);
}
if (document.getElementById('index-page')) {
    form_init();
  }

}

// Use jQuery to delay until page loaded.
$(init);

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
