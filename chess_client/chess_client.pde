import processing.net.*;
Client myClient;

color lightbrown=#FFFFC3;
color darkbrown=#D8864E;
PImage wrook,wbishop,wknight,wqueen,wking,wpawn;
PImage brook,bbishop,bknight,bqueen,bking,bpawn;
boolean firstClick,myTurn,undid,promoting,z,q,r,k,b;
int row1,col1,row2,col2;
char lastPieceTaken;

char grid[][] = {
  {'R','B','N','Q','K','N','B','R'}, 
  {'P','P','P','P','P','P','P','P'}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {' ',' ',' ',' ',' ',' ',' ',' '}, 
  {'p','p','p','p','p','p','p','p'}, 
  {'r','b','n','q','k','n','b','r'}
};

void setup(){
  size(800,800);
  textAlign(CENTER,CENTER);
  myClient=new Client(this,"127.0.0.1",1234);
  firstClick=true;
  myTurn=false;
  promoting=false;
  lastPieceTaken = ' ';

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
  if(z)undoMove();
  for(int i=0;i<8;i++){
    if(grid[7][i]=='P'){
      promoting=true;
      pawnPromote();
      break;
    }
  }
}
//Custom Functions
void receiveMove(){
  if(myClient.available()>0){
    String incoming=myClient.readString();
    int r1=int(incoming.substring(0,1));
    int c1=int(incoming.substring(2,3));
    int r2=int(incoming.substring(4,5));
    int c2=int(incoming.substring(6,7));
    String un=incoming.substring(8);
    grid[r2][c2]=grid[r1][c1];
    grid[r1][c1]=' ';
    println(un);
    if(un.equals("false")){
      myTurn=true;
    }else{
      
    }
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
    lastPieceTaken=' ';
    myTurn=true;
    undid=true;
  }
    //if(grid[row2][col2]=='P'){
    //  grid[befr][befc]='P';
    //  grid[row2][col2]=lastPieceTaken;
    //  myTurn=true;
    //  undid=true;
    //}if(grid[row2][col2]=='Q'){
    //  grid[befr][befc]='Q';
    //  grid[row2][col2]=lastPieceTaken;
    //  myTurn=true;
    //  undid=true;
    //}if(grid[row2][col2]=='R'){
    //  grid[befr][befc]='R';
    //  grid[row2][col2]=lastPieceTaken;
    //  myTurn=true;
    //  undid=true;
    //}if(grid[row2][col2]=='K'){
    //  grid[befr][befc]='K';
    //  grid[row2][col2]=lastPieceTaken;
    //  myTurn=true;
    //  undid=true;
    //}if(grid[row2][col2]=='N'){
    //  grid[befr][befc]='N';
    //  grid[row2][col2]=lastPieceTaken;
    //  myTurn=true;
    //  undid=true;
    //}if(grid[row2][col2]=='B'){
    //  grid[befr][befc]='B';
    //  grid[row2][col2]=lastPieceTaken;
    //  myTurn=true;
    //  undid=true;
    //}
    myClient.write(row1+","+col1+","+row2+","+col2+","+undid);
}
void pawnPromote(){
  if(promoting){
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
    if(q)grid[row2][col2]='Q';
    if(k)grid[row2][col2]='N';
    if(r)grid[row2][col2]='R';
    if(b)grid[row2][col2]='B';
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
  if(key=='z'||key=='Z')z=true;
  if(key=='q'||key=='Q')q=true;
  if(key=='r'||key=='R')r=true;
  if(key=='k'||key=='K')k=true;
  if(key=='b'||key=='B')b=true;
}
void keyReleased(){
  if(key=='z'||key=='Z')z=false;
  if(key=='q'||key=='Q')q=false;
  if(key=='r'||key=='R')r=false;
  if(key=='k'||key=='K')k=false;
  if(key=='b'||key=='B')b=false;
}
void mouseReleased(){
  if(firstClick&&myTurn&&!promoting){
    row1=mouseY/100;
    col1=mouseX/100;
    if(grid[row1][col1]=='P'||grid[row1][col1]=='R'||grid[row1][col1]=='Q'||grid[row1][col1]=='N'||grid[row1][col1]=='B'||grid[row1][col1]=='K')firstClick=false;
  }else if(myTurn&&!promoting){
    row2=mouseY/100;
    col2=mouseX/100;
    if(!(row2==row1&&col2==col1)){
      lastPieceTaken=grid[row2][col2];
      grid[row2][col2]=grid[row1][col1];
      grid[row1][col1]=' ';
      undid=false;
      myClient.write(row1+","+col1+","+row2+","+col2+","+undid);
      myTurn=false;
      firstClick=true;
    }else{
      firstClick=true;
    }
  }
}
