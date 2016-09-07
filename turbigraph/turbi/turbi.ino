// Reports the frequency from the TSL230, higher number means brighter
// Part: http://www.sparkfun.com/products/8940
// Article:  http://bildr.org/2011/08/tsl230r-arduino/
// I also added communication wit an sd card
// Then time logging
// and used the function for measuring frequency from open turbdity project


#include <SD.h>
#include <PinChangeInt.h>

int TSL230_Pin = 4; //TSL230 output
int TSL230_s0 =5; //TSL230 sensitivity setting 1
int TSL230_s1 = 6; //TSL230 sensitivity setting 2
int TSL230_samples = 6; //higher = slower but more stable and accurate
int LED_pin = 2;
int LED_180 = 3;
int SAMPLING_WINDOW = 1000; //this value is how long the sensor counts the pulses in ms
#define VPIN A4 // This is voltage reading 


// On the Ethernet Shield, CS is pin 4. Note that even if it's not
// used as the CS pin, the hardware CS pin (10 on most Arduino boards,
// 53 on the Mega) must be left as an output or the SD library
// functions will not work.
const int chipSelect = 10;
volatile unsigned long pulse_count = 0;


void setup(){
 
  
  Serial.begin(9600); //seting up serial communication
  
  //Pin I/O settings 
  pinMode(LED_pin, OUTPUT); //
  pinMode(LED_180, OUTPUT); // set the other pin in right position
  
  setupTSL230();      // setting up the sensor
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  
  // SD card initialization protocol
  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  //we need this to function properly 
  pinMode(chipSelect, OUTPUT);
  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");

  delay(10);
  
  //startup procedure
  digitalWrite(LED_pin, LOW);
  digitalWrite(LED_180, LOW);
}


void loop(){
  //String xxx="na";
  // make a string for assembling the data to log:
   // int lightLevel = readTSL230(TSL230_samples);     // This initiates the sensor values
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  //dtostrf(lightLevel, 6, 2, xxx);
  //String dataString = xxx;
  //dataString += "timestamp";         // With the time stamp for every measurement
  //dataString += ", ";
  //dataString += millis();          // print the value to serial... we want to print to file 
  
  int lightLevel = readTSL230(TSL230_samples);     // This initiates the sensor values
  int level180 = readTSL230_180(TSL230_samples);  // value of the second LED
  
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  //dtostrf(lightLevel, 6, 2, xxx);
  String dataString = String(lightLevel,DEC);
  dataString += ", ";
  dataString += level180;
  dataString += ", ";
  dataString += millis();          // print the value to serial... we want to print to file 
  //String outcome = lightLevel 

  File dataFile = SD.open("datalog.txt", FILE_WRITE);

  // if the file is available, write to it:
  if (dataFile) {
    dataFile.println(dataString);
    dataFile.close();
    // print to the serial port too:
    Serial.println(dataString);
  }  
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening datalog.txt");
  }  
  
  
delay(1000);

}

void setupTSL230(){
  pinMode(TSL230_s0, OUTPUT); 
  pinMode(TSL230_s1, OUTPUT); 

  //configure sensitivity - Can set to
  //S1 LOW  | S0 HIGH: low
  //S1 HIGH | S0 LOW:  med
  //S1 HIGH | S0 HIGH: high

  digitalWrite(TSL230_s1, HIGH);
  digitalWrite(TSL230_s0, HIGH);
}



float readTSL230(int samples){
//sample light, return reading in frequency
//higher number means brighter

  float start = millis();  
  digitalWrite(LED_pin, HIGH); // turn on the LED
  int rep_cnt = 0;
  long sum = 0, low =1000000, high = 0; int rd = 0; //what are these?
  PCintPort::attachInterrupt(TSL230_Pin, add_pulse, RISING); //counting on
  delay(200);
  pulse_count = 0;
  start = 0;
  while(rep_cnt <  samples){
    if(millis() - start >= SAMPLING_WINDOW){ // ned to define sampling window
      rd = pulse_count;       // *scale divider the problem is here that i do not use scale div.
      // here the lowest and highest are discarded. Im not using this 
      sum += rd; // sum the readings
      start = millis();
      rep_cnt++;
      pulse_count=0;
    }
  }
  PCintPort::detachInterrupt(TSL230_Pin); //turn off frequency counting
  digitalWrite(LED_pin, LOW);
  float raw_value = float(sum) / float(samples);
  return raw_value;
  delay(10);
  
}

float readTSL230_180(int samples){
//sample light, return reading in frequency
//higher number means brighter

  float start = millis();  
  digitalWrite(LED_180, HIGH); // turn on the LED
  int rep_cnt = 0;
  long sum = 0, low =1000000, high = 0; int rd = 0; //what are these?
  PCintPort::attachInterrupt(TSL230_Pin, add_pulse, RISING); //counting on
  delay(200);
  pulse_count = 0;
  start = 0;
  while(rep_cnt <  samples){
    if(millis() - start >= SAMPLING_WINDOW){ // ned to define sampling window
      rd = pulse_count;       // *scale divider the problem is here that i do not use scale div.
      // here the lowest and highest are discarded. Im not using this 
      sum += rd; // sum the readings
      start = millis();
      rep_cnt++;
      pulse_count=0;
    }
  }
  PCintPort::detachInterrupt(TSL230_Pin); //turn off frequency counting
  digitalWrite(LED_180, LOW);
  float raw_value = float(sum) / float(samples);
  return raw_value;
  delay(10);
  
}

void add_pulse(){
  pulse_count++;
}

