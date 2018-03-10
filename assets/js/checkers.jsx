import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

'use strict';
export default function run_demo(root,channel) {
  ReactDOM.render(<Board channel={channel}/>, root);
}

class Board extends React.Component {


  addTiles(start,row){
    var  lis=[];
    for(var i= 0;i<8;i++){
    var color=(start+ i%2)== 1 ? "dark" : "light";
      lis.push(<Tile  key={row+i} classname={color}/>);
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
