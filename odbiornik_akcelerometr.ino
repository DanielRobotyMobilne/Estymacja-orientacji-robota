#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include <Wire.h>

#define MA_1 3
#define MA_2 5
#define MB_1 6
#define MB_2 9

const int MPU_ADDR = 0x68; // I2C address of the MPU-6050. If AD0 pin is set to HIGH, the I2C address will be 0x69.
int16_t temperature; // variables for temperature data
char tmp_str[7]; // temporary variable used in convert function

RF24 radio(8, 7); // CE, CSN
const byte addresses[][6] = {"00001", "00002"};

int FB = 0;
int LR = 0;
int MA = 0;
int MB = 0;
int Controls[2] = {0, 0};
int16_t Data[6] = {5, 6, 7, 8, 9, 10};

void setup() {
    Serial.begin(9600);
    radio.begin();
    radio.openWritingPipe(addresses[0]); // 00002
    radio.openReadingPipe(1, addresses[1]); // 00001
    radio.setPALevel(RF24_PA_MIN);
    Wire.begin();
    Wire.beginTransmission(MPU_ADDR); // Begins a transmission to the I2C slave (GY-521 board)
    Wire.write(0x6B); // PWR_MGMT_1 register
    Wire.write(0); // set to zero (wakes up the MPU-6050)
    Wire.endTransmission(true);
}

void loop() {

  radio.startListening();
  while (radio.available()) {
      radio.read(&Controls, sizeof(Controls));
  }
  
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(0x3B); // starting with register 0x3B (ACCEL_XOUT_H) [MPU-6000 and MPU-6050 Register Map and Descriptions Revision 4.2, p.40]
  Wire.endTransmission(false); // the parameter indicates that the Arduino will send a restart. As a result, the connection is kept active.
  Wire.requestFrom(MPU_ADDR, 7*2, true); // request a total of 7*2=14 registers
  
  // "Wire.read()<<8 | Wire.read();" means two registers are read and stored in the same variable
  Data[0] = Wire.read()<<8 | Wire.read(); // reading registers: 0x3B (ACCEL_XOUT_H) and 0x3C (ACCEL_XOUT_L)
  Data[1] = Wire.read()<<8 | Wire.read(); // reading registers: 0x3D (ACCEL_YOUT_H) and 0x3E (ACCEL_YOUT_L)
  Data[2] = Wire.read()<<8 | Wire.read(); // reading registers: 0x3F (ACCEL_ZOUT_H) and 0x40 (ACCEL_ZOUT_L)
  temperature = Wire.read()<<8 | Wire.read(); // reading registers: 0x41 (TEMP_OUT_H) and 0x42 (TEMP_OUT_L)
  Data[3] = Wire.read()<<8 | Wire.read(); // reading registers: 0x43 (GYRO_XOUT_H) and 0x44 (GYRO_XOUT_L)
  Data[4] = Wire.read()<<8 | Wire.read(); // reading registers: 0x45 (GYRO_YOUT_H) and 0x46 (GYRO_YOUT_L)
  Data[5] = Wire.read()<<8 | Wire.read(); // reading registers: 0x47 (GYRO_ZOUT_H) and 0x48 (GYRO_ZOUT_L)

  

  FB = Controls[0];
  LR = Controls[1];
  if (LR<-150){
    MA = 0;
    MB = abs(FB);
  }
  else{
    if (LR>150){
      MA = abs(FB);
      MB = 0;
    }
    else{
      MA = abs(FB);
      MB = abs(FB);
    }
  }

  if(FB<0){
    analogWrite(MA_1,0);
    analogWrite(MA_2,MA);
    analogWrite(MB_1,0);
    analogWrite(MB_2,MB);
    }
    else{
        analogWrite(MA_1,MA);
        analogWrite(MA_2,0);
        analogWrite(MB_1,MB);
        analogWrite(MB_2,0);
      }  
  
  radio.stopListening();
  radio.write(&Data, sizeof(Data));
  
  Serial.print( " Gz: "); 
   Serial.print(FB);
   Serial.println("");
  
}
