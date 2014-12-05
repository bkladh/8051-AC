
#line 1 "Automatic Air condition.c" /0







 
 
  
#line 1 "C:\KEIL\C51\INC\ATMEL\REG51.H" /0






 
 
 
 
 
 
 sfr P0   = 0x80;
 sfr P1   = 0x90;
 sfr P2   = 0xA0;
 sfr P3   = 0xB0;
 sfr PSW  = 0xD0;
 sfr ACC  = 0xE0;
 sfr B    = 0xF0;
 sfr SP   = 0x81;
 sfr DPL  = 0x82;
 sfr DPH  = 0x83;
 sfr PCON = 0x87;
 sfr TCON = 0x88;
 sfr TMOD = 0x89;
 sfr TL0  = 0x8A;
 sfr TL1  = 0x8B;
 sfr TH0  = 0x8C;
 sfr TH1  = 0x8D;
 sfr IE   = 0xA8;
 sfr IP   = 0xB8;
 sfr SCON = 0x98;
 sfr SBUF = 0x99;
 
 
 
 
 sbit CY   = 0xD7;
 sbit AC   = 0xD6;
 sbit F0   = 0xD5;
 sbit RS1  = 0xD4;
 sbit RS0  = 0xD3;
 sbit OV   = 0xD2;
 sbit P    = 0xD0;
 
 
 sbit TF1  = 0x8F;
 sbit TR1  = 0x8E;
 sbit TF0  = 0x8D;
 sbit TR0  = 0x8C;
 sbit IE1  = 0x8B;
 sbit IT1  = 0x8A;
 sbit IE0  = 0x89;
 sbit IT0  = 0x88;
 
 
 sbit EA   = 0xAF;
 sbit ES   = 0xAC;
 sbit ET1  = 0xAB;
 sbit EX1  = 0xAA;
 sbit ET0  = 0xA9;
 sbit EX0  = 0xA8;
 
 
 sbit PS   = 0xBC;
 sbit PT1  = 0xBB;
 sbit PX1  = 0xBA;
 sbit PT0  = 0xB9;
 sbit PX0  = 0xB8;
 
 
 sbit RD   = 0xB7;
 sbit WR   = 0xB6;
 sbit T1   = 0xB5;
 sbit T0   = 0xB4;
 sbit INT1 = 0xB3;
 sbit INT0 = 0xB2;
 sbit TXD  = 0xB1;
 sbit RXD  = 0xB0;
 
 
 sbit SM0  = 0x9F;
 sbit SM1  = 0x9E;
 sbit SM2  = 0x9D;
 sbit REN  = 0x9C;
 sbit TB8  = 0x9B;
 sbit RB8  = 0x9A;
 sbit TI   = 0x99;
 sbit RI   = 0x98;
 
 
#line 10 "Automatic Air condition.c" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 sbit rd=P2^5;	   
 sbit wr=P2^4;	   
 sbit INTR=P2^3;	   
 sbit rs=P2^0;	   
 sbit rw=P2^1;	   
 sbit en=P2^2;	   
 sbit MTR=P2^6;	   
 sbit HTR1=P0^0;	   
 sbit HTR2=P0^1;	   
 sbit busy=P1^7;	   
 





 
 
 void msDelay(unsigned int value){  

 unsigned int x,y;
 for(x=0;x<value;x++)
 for(y=0;y<1275;y++);   
 }
 
 
 void lcdReady(){   
 busy=1;
 rs=0;
 rw=1;
 while(busy==1)
 {
 en=0;
 en=1;
 }
 return;
 }
 
 void lcdCmd(unsigned char value){  
 lcdReady(); 
  P1=value;
 rs=0;
 rw=0; 
 en=1; 
 en=0;
 return;
 }
 
 
 void lcdInit(){  
 lcdCmd(0x38);
 lcdCmd(0x0c);
 lcdCmd(0x01);
 lcdCmd(0x80);
 return;
 }
 
 void lcdData(char value){  
  P1=value;
 rs=1;
 rw=0;
 en=1;
 en=0;
 return;
 }
 
 void display(char d1,char d2){
 lcdData(d2);
 msDelay(30);
 msDelay(30);
 lcdData(d1);
 msDelay(30);
 msDelay(' ');
 msDelay(30);
 lcdData('C');
 }
 
 
 
 void convert(char value){ 
 char y,d1,d2,d3;
 y=value/10;
 d1=value%10;
 d2=y%10;
 d3=y/10;
 d1=d1|0x30;
 d2=d2|0x30;
 d3=d3|0x30;
 display(d1,d2); 



 }
 
 void update(char value){ 
 char y,d1,d2,d3;      
 y=value/10;       
 d1=value%10;
 d2=y%10;
 d3=y/10;
 d1=d1|0x30;
 d2=d2|0x30;
 d3=d3|0x30;
 lcdData(d2);
 msDelay(30);
 msDelay(30);
 lcdData(d1);
 msDelay(30);
 lcdCmd(0xc0);
 }
 
 
 
 char adcRead(){ 
 char value;
 wr=0; 
 wr=1;
 while(INTR==1); 
 rd=0; 
 value=P3; 
 rd=1; 
 return value;
 }
 
 
 void motorcontrol(){
 unsigned char i;
 unsigned char value;
 unsigned char x[6]="TEMPR:"; 
 unsigned char x1[5]="FANON"; 
 unsigned char x2[5]="HTRON"; 
 unsigned char y[12]="SPEED:LEVEL";
 unsigned char z[11]="HEAT:LEVEL";
 unsigned char u1[5]="NORM."; 
 unsigned char u2[11]="FAN,HTR OFF"; 
 
 while(1){   

 value=adcRead();  
 if(value<20){  
 lcdCmd(0x01);    
 for(i=0;i<6;i++)  
 {
 msDelay(50);
 lcdData(x[i]);
 }
 convert(value);  
 lcdCmd(0x8b);					 
 for(i=0;i<5;i++){  
 msDelay(30);
 lcdData(x2[i]);
 }
 
 while(value>10 && value<20){  
 MTR=1;  
 HTR2=1;
 HTR1=0;
 msDelay(1);
 z[10]='1';
 lcdCmd(0xc0);
 for(i=0;i<11;i++){
 msDelay(30);
 lcdData(z[i]);
 }
 bkl5:
 value=adcRead();
 if(value>10 && value<20){
 lcdCmd(0x86);
 update(value);
 goto bkl5;
 }
 else
 break;
 }  
 
 while(value>=00 && value<=10){  
 MTR=1;
 HTR1=0;
 msDelay(30);
 HTR2=0;
 msDelay(1);
 lcdCmd(0xc0);
 z[10]='2';
 for(i=0;i<11;i++){
 msDelay(30);
 lcdData(z[i]);
 }
 bkl6:
 value=adcRead();
 if(value>=00 && value<=10){
 lcdCmd(0x86);
 update(value);
 goto bkl6;
 }
 else
 break;
 }  
 
 
 }  
 
 
 while(value>=20&&value<25){  
 HTR1=1;
 HTR2=1;
 MTR=1;
 lcdCmd(0x01);  
 for(i=0;i<6;i++){  
 msDelay(50);
 lcdData(x[i]);
 }
 convert(value);  
 for(i=0;i<5;i++){
 msDelay(30);
 lcdData(u1[i]);
 }
 lcdCmd(0xc0);
 for(i=0;i<11;i++){
 msDelay(30);
 lcdData(u2[i]);
 }
 bklbkl:
 value=adcRead();
 if(value>=20&&value<25){
 lcdCmd(0x86);
 update(value);
 goto bklbkl;
 }
 else
 break;
 }
 
 
 
 if(value>=25)  
 {
 HTR1=1;
 HTR2=1;
 lcdCmd(0x01);  
 for(i=0;i<6;i++)  
 {
 msDelay(50);
 lcdData(x[i]);
 }
 convert(value);  
 lcdCmd(0x8b);
 for(i=0;i<5;i++)
 {
 msDelay(30);
 lcdData(x1[i]);
 }
 
 
 
 
 while(value>=25 && value<30){  
 lcdCmd(0xc0);
 y[11]='1';
 for(i=0;i<12;i++){
 msDelay(30);
 lcdData(y[i]);
 }
 bkl1:
 MTR=0;
 msDelay(50);
 MTR=1;
 msDelay(50);
 value=adcRead();
 if(value>=25 && value<30){   
 lcdCmd(0x86);
 update(value);
 goto bkl1;
 }
 else
 break;
 
 }  
 
 
 
 while(value>=30 && value<35){  
 y[11]='2';
 lcdCmd(0xc0);
 for(i=0;i<12;i++){
 msDelay(30);
 lcdData(y[i]);
 }
 bkl2:
 MTR=0;
 msDelay(75);
 MTR=1;
 msDelay(25);
 value=adcRead();
 if(value>=30 && value<35){
 lcdCmd(0x86);
 update(value);
 goto bkl2;
 }
 else
 break;
 }  
 
 
 
 while(value>=35){  
 y[11]='3';
 lcdCmd(0xc0);
 for(i=0;i<12;i++){
 msDelay(30);
 lcdData(y[i]);
 }
 bkl3:
 MTR=0;
 value=adcRead();
 if(value>=35){
 lcdCmd(0x86);
 update(value);
 goto bkl3;
 }
 else
 break;
 }  
 
 
 
 }  
 }  
 }  
 
 void main(){  
 P0=0xff;	  
  P3=0xff;  
 INTR=1; 
 rd=1; 
 wr=1; 
 MTR=1; 
 HTR1=0; 
 HTR2=0; 
 msDelay(50);
 HTR1=1; 
 HTR2=1;
 lcdInit(); 
 motorcontrol(); 
 }  
 
 
 
 
 
 
