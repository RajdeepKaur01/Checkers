import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

'use strict';
export default function run_demo(root,channel,players) {
  ReactDOM.render(<Board channel={channel}/>, root);
}

class Board extends React.Component {


  constructor(props) {
    super(props);
    this.channel=props.channel;
    this.state = {
      tiles: [],
      kings: [],
    };
    this.channel.join()
    .receive("ok", this.gotView.bind(this))
    .receive("error", resp => { console.log("Unable to join", resp) });
  }

  gotView(view) {
    console.log("New view", view);
    this.setState(view.game);
  }

  addTiles(start,row){
    var  lis=[];
    for(var i= 0;i<8;i++){
      var color=(start+ i%2)== 1 ? "dark" : "light";
      //console.log(this.state.tiles[i]);
      if(this.state.tiles[i+(row-1)*8]==1){
        lis.push(<BlackTile  key={i+(row-1)*8} classname={color}/>);
      }
      else if(this.state.tiles[i+(row-1)*8]==-1) lis.push(<WhiteTile  key={i+(row-1)*8} classname={color}/>);
      else lis.push(<Tile  key={i+(row-1)*8} classname={color}/>);
    }
    return lis;
  }

  render() {
    var lis= [];
    var start=0;
    for(var i=1;i<9;i++){
      start=i%2==0? 1 :0;
      lis.push(<div key={i} className="board-row">{this.addTiles(start,i)}</div>);
    }
    return (
      <div>

      <div>
      {lis}
      </div>
      <br></br>
      </div>
    );
  }
}

function Tile(props){

  return (
    <button className={"btn btn-default " + props.classname}>
    </button>
  );
}

function BlackTile(props){

  return (
    <button className={"btn btn-default " + props.classname}>
    <img src="/images/Black_Circle.png" />
    </button>
  );
}

function WhiteTile(props){

  return (
    <button className={"btn btn-default " + props.classname}>
    <img src="/images/Brown_Circle.png" />
    </button>
  );
}
