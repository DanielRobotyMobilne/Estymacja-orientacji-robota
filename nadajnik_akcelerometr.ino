#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

RF24 radio(8, 9); // CE, CSN
const byte addresses[][6] = {"00001", "00002"};

int J1 = 0;
int J2 = 0;
int16_t Time = 0;
int Controls[2] = {0, 0};
int16_t Data[6] = {0, 0, 0, 0, 0, 0};

void setup() {
  Serial.begin(9600);
  radio.begin();
  radio.openWritingPipe(addresses[1]); // 00001
  radio.openReadingPipe(1, addresses[0]); // 00002
  radio.setPALevel(RF24_PA_MIN);
  
}

void loop() {
  
  J1 = analogRead(A0);
  J2 = analogRead(A1);

  Controls[0] = map(J1, 0, 1023, -255, 255);
  Controls[1] = map(J2, 0, 1023, -255, 255);

  radio.startListening();
  while (radio.available()){
    radio.read(&Data, sizeof(Data));
        }
   

   Serial.print(Data[0]); 
   Serial.print( " "); 
   Serial.print(Data[1]);  
   Serial.print(" "); 
   Serial.print(Data[2]); 
   Serial.print( " "); 
   Serial.print(Data[3]);  
   Serial.print(" "); 
   Serial.print(Data[4]); 
   Serial.print( " "); 
   Serial.print(Data[5]);
   Serial.print(" ");

   Serial.print(micros());
   Serial.println("");
   

   radio.stopListening();
  radio.write(&Controls, sizeof(Controls));

        
}
