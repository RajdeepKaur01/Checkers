import "phoenix_html"
import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

'use strict';
export default function run_demo(root,channel) {
  ReactDOM.render(<Board channel={channel} />, root);
}

class Board extends React.Component {


  constructor(props) {
    super(props);
    this.channel=props.channel;
    //  this.players=props.players;
    this.state = {
      tiles: [],
      kings: [],
      turn: true,
      winner: null,
      prev: null,
      players: {},
      spectators: new Set(),
      moves: 0,
      nextTurn: 0,
    };
    this.channel.join()
    .receive("ok", this.gotView.bind(this))
    .receive("error", resp => { console.log("Unable to join", resp) });

    this.channel.push("addUser", { username: window.userName, gamename: window.gameName});
  }

  componentDidMount() {

    this.channel.on("game_update",payload => {this.setState(payload);});
    this.channel.on("user_update",payload => {this.setState(payload);});
    this.channel.on("user_gone",payload => {this.setState(payload);});
    this.channel.on("restart",payload => {this.setState(payload);});
  }



  handleClick(id) {
    this.channel.push("handleClick", { num: id, name: window.gameName });
  }

  restart(){
    this.channel.push("restart");
  }

  gotView(view) {

    this.setState(view.game);
  }

  addTiles(start,row){
    var  lis=[];

    for(var i= 0;i<8;i++){
      var id=i+(row-1)*8;

      var color=(start+ i%2)== 1 ? "dark" : "light";

      if(this.state.tiles[id]==1){
        lis.push(<Tile  val={id} dice="black" root={this}  key={id} classname={color} onClick={() => {this.handleClick(id)}}/>);
      }
      else if(this.state.tiles[id]==-1) lis.push(<Tile dice="white"   root={this}  val={id} key={id} classname={color} onClick={() =>{this.handleClick(id)}}/>);
      else lis.push(<Tile dice="nodice"  root={this} key={id} val={id} classname={color} onClick={() => {this.handleClick(id)}}/>);
    }
    return lis;
  }

  addSpectators(){
    let lis=[];

    for(let item of this.state.spectators){
      lis.push(<li key={item}>{item}</li>);
    }
    return lis;
  }

  addPlayers(){
    let lis=[];
    if(this.state.players.player1!=null) lis.push(<li key="player1">{this.state.players.player1}</li>);
    if(this.state.players.player2!=null) lis.push(<li key="player2">{this.state.players.player2}</li>);
    return lis;
  }


  render() {

    var lis= [];
    var start=0;
    var divclass;
    if(this.state.players.player1== null || this.state.players.player2== null || this.state.winner != null) divclass= "unclickable";
    else if(window.userName==this.state.players.player1 && this.state.turn) divclass= "clickable";
    else if(window.userName==this.state.players.player2 && !this.state.turn) divclass= "clickable";
    else divclass= "unclickable";

    var status;
    if(this.state.players.player1==null || this.state.players.player2== null) status= "";
    else if(this.state.winner != null){
      if(this.state.winner==0) status = "Game Draw";
      else status = "Winner: "+ (this.state.winner==1 ? this.state.players.player1 :this.state.players.player2)
    }
    else status= "Now Playing : " + (this.state.turn? this.state.players.player1 : this.state.players.player2) ;
    for(var i=1;i<9;i++){
      start=i%2==0? 1 :0;
      lis.push(<div key={"div"+i} className="board-row">{this.addTiles(start,i)}</div>);
    }

    let specLis=[];
    specLis.push(<ul key="unique">{this.addSpectators()}</ul>);
    let playerLis= <ul>{this.addPlayers()}</ul>

    let restartButton="";
    if(window.userName==this.state.players.player1 || window.userName==this.state.players.player2)
    restartButton= <button onClick={()=>{this.restart()}}>RESTART</button>

    return (
      <div>
      <div><h2 className="status">{status}</h2></div>
      <div className="row">
      <div className="col-lg-3 nopadding">
      <h2>Players</h2>
      {playerLis}
      </div>
      <div className={divclass +" col-lg-6 nopadding"} >
      {lis}
      </div>
      <div className="col-lg-3 nopadding">
      <h2>Spectators</h2>
      {specLis}
      </div>
      </div><br></br>
      <div className="restart">{restartButton}</div>
      </div>
    );
  }
}

function Tile(props){
  var dice_image="";
  let id= props.val;
  let prev= props.root.state.prev== id ? "clicked" : "";
  if(props.dice=="black" && props.root.state.kings[id]==1) dice_image= <img  src="/images/black_king.png" />;
  else if(props.dice=="black") dice_image= <img  src="/images/black.png" />;
  else if (props.dice=="white" && props.root.state.kings[id]==1) dice_image= <img src="/images/brown_king.png" />;
  else if(props.dice=="white") dice_image= <img  src="/images/brown.png" />;

  return (
    <button className={"btn btn-default " + props.classname+" "+ prev} onClick={() => props.root.handleClick(id)}>
    {dice_image}
    </button>
  );
}
