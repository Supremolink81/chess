import processing.net.*;
ArrayList<Client>clients;
Server myServer;

color lightbrown=#FFFFC3;
color darkbrown=#D8864E;
PImage wrook,wbishop,wknight,wqueen,wking,wpawn;
PImage brook,bbishop,bknight,bqueen,bking,bpawn;
boolean firstClick,myTurn,undid,z,q,r,k,b;
int row1,col1,row2,col2,befr,befc;

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
  myServer=new Server(this,1234);
  firstClick=true;
  myTurn=true;

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
  pawnPromote();
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
    String un=incoming.substring(8);
    grid[r2][c2]=grid[r1][c1];
    grid[r1][c1]=' ';
    println(un);
    if(un.equals("false"))myTurn=true;
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
  if(firstClick&&!myTurn){
    if(grid[row2][col2]=='p'){
      grid[befr][befc]='p';
      grid[row2][col2]=' ';
      myTurn=true;
      undid=true;
    }if(grid[row2][col2]=='q'){
      grid[befr][befc]='q';
      grid[row2][col2]=' ';
      myTurn=true;
      undid=true;
    }if(grid[row2][col2]=='r'){
      grid[befr][befc]='r';
      grid[row2][col2]=' ';
      myTurn=true;
      undid=true;
    }if(grid[row2][col2]=='k'){
      grid[befr][befc]='k';
      grid[row2][col2]=' ';
      myTurn=true;
      undid=true;
    }if(grid[row2][col2]=='n'){
      grid[befr][befc]='n';
      grid[row2][col2]=' ';
      myTurn=true;
      undid=true;
    }if(grid[row2][col2]=='b'){
      grid[befr][befc]='b';
      grid[row2][col2]=' ';
      myTurn=true;
      undid=true;
    }myServer.write(row2+","+col2+","+befr+","+befc+","+undid);
  }
}
void pawnPromote(){
  for(int i=0;i<8;i++){
    if(grid[0][i]=='p'){
      
    }
  }
}
void highlightSquare(){
  if(!firstClick){
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
  if(firstClick&&myTurn){
    row1=mouseY/100;
    col1=mouseX/100;
    if(grid[row1][col1]=='p'||grid[row1][col1]=='r'||grid[row1][col1]=='q'||grid[row1][col1]=='n'||grid[row1][col1]=='b'||grid[row1][col1]=='k')firstClick=false;
  }else if(myTurn){
    row2=mouseY/100;
    col2=mouseX/100;
    if(!(row2==row1&&col2==col1)){
      grid[row2][col2]=grid[row1][col1];
      befr=row1;
      befc=col1;
      grid[row1][col1]=' ';
      undid=false;
      myServer.write(row1+","+col1+","+row2+","+col2+","+undid);
      firstClick=true;
      myTurn=false;
    }else{
      firstClick=true;
    }
  }
}
