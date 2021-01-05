import processing.net.*;
ArrayList<Client>clients;
Server myServer;

color lightbrown=#FFFFC3;
color darkbrown=#D8864E;
PImage wrook,wbishop,wknight,wqueen,wking,wpawn;
PImage brook,bbishop,bknight,bqueen,bking,bpawn;
boolean firstClick,myTurn,undid,promoting,z,q,r,k,b;
String msg;
int row1,col1,row2,col2,j;
char lastPieceTaken;

char grid[][] = {
  {'R','N','B','Q','K','B','N','R'}, 
  {'P','P','P','P','P','P','P','P'}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {'p','p','p','p','p','p','p','p'}, 
  {'r','n','b','q','k','b','n','r'}
};
void setup(){
  size(800,800);
  textAlign(CENTER,CENTER);
  myServer=new Server(this,1234);
  firstClick=true;
  myTurn=true;
  promoting=false;
  lastPieceTaken=' ';
  j=0;

  brook=loadImage("blackRook.png");
  bbishop=loadImage("blackBishop.png");
  bknight=loadImage("blackKnight.png");
  bqueen=loadImage("blackQueen.png");
  bking=loadImage("blackKing.png");
  bpawn=loadImage("blackPawn.png");

  wrook=loadImage("whiteRook.png");
  wbishop=loadImage("whiteBishop.png");
  wknight=loadImage("whiteKnight.png");
  wqueen=loadImage("whiteQueen.png");
  wking=loadImage("whiteKing.png");
  wpawn=loadImage("whitePawn.png");
}
void draw(){
  drawBoard();
  drawPieces();
  highlightSquare();
  receiveMove();
  for(int i=0;i<8;i++){
    if(grid[0][i]=='p'){
      promoting=true;
      pawnPromote();
      break;
    }
  }
}
//Custom Functions
void receiveMove(){
  Client myClient=myServer.available();
  if(myClient!=null){
    String incoming=myClient.readString();
    int r1=int(incoming.substring(0,1));
    int c1=int(incoming.substring(2,3));
    int r2=int(incoming.substring(4,5));
    int c2=int(incoming.substring(6,7));
    String ms=incoming.substring(8);
    if(r1<=7&&r2<=7&&c1<=7&&c2<=7){
      grid[r2][c2]=grid[r1][c1];
      grid[r1][c1]=' ';
    }
    if(ms.equals("un"))myTurn=false;
    if(ms.equals("prom"))myTurn=false;
    if(ms.equals("q")){
      grid[r2][c2]='Q';
      myTurn=true;
    }
    if(ms.equals("r")){
      grid[r2][c2]='R';
      myTurn=true;
    }
    if(ms.equals("n")){
      grid[r2][c2]='N';
      myTurn=true;
    }
    if(ms.equals("b")){
      grid[r2][c2]='B';
      myTurn=true;
    }
    if(ms.equals("none"))myTurn=true;
  }
}
void drawPieces(){
  for (int r=0;r<8;r++) {
    for (int c=0;c<8;c++) {
      if(grid[r][c]=='r')image(wrook,c*100,r*100,100,100);
      if(grid[r][c]=='R')image(brook,c*100,r*100,100,100);
      if(grid[r][c]=='b')image(wbishop,c*100,r*100,100,100);
      if(grid[r][c]=='B')image(bbishop,c*100,r*100,100,100);
      if(grid[r][c]=='n')image(wknight,c*100,r*100,100,100);
      if(grid[r][c]=='N')image(bknight,c*100,r*100,100,100);
      if(grid[r][c]=='q')image(wqueen,c*100,r*100,100,100);
      if(grid[r][c]=='Q')image(bqueen,c*100,r*100,100,100);
      if(grid[r][c]=='k')image(wking,c*100,r*100,100,100);
      if(grid[r][c]=='K')image(bking,c*100,r*100,100,100);
      if(grid[r][c]=='p')image(wpawn,c*100,r*100,100,100);
      if(grid[r][c]=='P')image(bpawn,c*100,r*100,100,100);
    }
  }
}
void drawBoard(){
  noStroke();
  for(int r=0;r<8;r++){
    for(int c=0;c<8;c++){ 
      if((r%2)==(c%2)){ 
        fill(lightbrown);
      }else{ 
        fill(darkbrown);
      }
      rect(c*100,r*100,100,100);
    }
  }
}
void undoMove(){
  if(firstClick&&!myTurn&&!promoting){
    grid[row1][col1]=grid[row2][col2];
    grid[row2][col2]=lastPieceTaken;
    myTurn=true;
    msg="un";
    myServer.write(row2+","+col2+","+row1+","+col1+","+msg);
  }
}
void pawnPromote(){
  if(promoting){
    while(j<1){
      myServer.write(9+","+9+","+9+","+9+","+"prom");
      j++;
    }
    fill(255);
    rect(width/2-200,height/2-100,400,200);
    fill(0);
    textSize(40);
    text("Promote a Piece",width/2,height/1.8);
    textSize(20);
    text("Q = Queen",width/2-60,height/1.8-80);
    text("K = Knight",width/2+60,height/1.8-80);
    text("R = Rook",width/2-60,height/1.8-40);
    text("B = Bishop",width/2+60,height/1.8-40);
    if(q){
      grid[row2][col2]='q';
      msg="q";
      promoting=false;
      j=0;
      myServer.write(row1+","+col1+","+row2+","+col2+","+msg);
    }
    if(k){
      grid[row2][col2]='n';
      msg="n";
      promoting=false;
      j=0;
      myServer.write(row1+","+col1+","+row2+","+col2+","+msg);
    }
    if(r){
      grid[row2][col2]='r';
      msg="r";
      promoting=false;
      j=0;
      myServer.write(row1+","+col1+","+row2+","+col2+","+msg);
    }
    if(b){
      grid[row2][col2]='b';
      msg="b";
      promoting=false;
      j=0;
      myServer.write(row1+","+col1+","+row2+","+col2+","+msg);
    }
  }
}
void highlightSquare(){
  if(!firstClick&&!promoting){
    noFill();
    stroke(255,0,0);
    strokeWeight(5);
    rect(col1*100,row1*100,100,100);
  }
}
//Keyboard Inputs
void keyPressed(){
  if(key=='q'||key=='Q')q=true;
  if(key=='r'||key=='R')r=true;
  if(key=='k'||key=='K')k=true;
  if(key=='b'||key=='B')b=true;
}
void keyReleased(){
  if(key=='z'&&!myTurn||key=='Z'&&!myTurn) undoMove();
  if(key=='q'||key=='Q')q=false;
  if(key=='r'||key=='R')r=false;
  if(key=='k'||key=='K')k=false;
  if(key=='b'||key=='B')b=false;
}
void mouseReleased(){
  if(firstClick&&myTurn&&!promoting){
    row1=mouseY/100;
    col1=mouseX/100;
    if(grid[row1][col1]=='p'||grid[row1][col1]=='r'||grid[row1][col1]=='q'||grid[row1][col1]=='n'||grid[row1][col1]=='b'||grid[row1][col1]=='k')firstClick=false;
  }else if(myTurn&&!promoting){
    row2=mouseY/100;
    col2=mouseX/100;
    if(!(row2==row1&&col2==col1)){
      lastPieceTaken=grid[row2][col2];
      grid[row2][col2]=grid[row1][col1];
      grid[row1][col1]=' ';
      msg="none";
      myServer.write(row1+","+col1+","+row2+","+col2+","+msg);
      myTurn=false;
      firstClick=true;
    }else{
      firstClick=true;
    }
  }
}
