/*
      FILE: TSL235
    AUTHOR: Wojciech Francuzik
      DATE: 2016 07 20

   PURPOSE: prototype TSL235R monitoring

   Digital Pin layout Wemos D1 mini
   =============================
    D0 IRQ 0    - to TSL235R
    D5 IRQ 1
    D6 IRQ 2
    D7 IRQ 3

    D8 LED0
    D1 LED1
    D2 LED2
    D3 LED3

   TSL235R pinout from left to right
   PIN 1 - GND
   PIN 2 - VDD - 5V
   PIN 3 - SIGNAL

*/


// setting up the variable names
volatile unsigned long cnt[4]; //this is for counting the pulses from thefirst sensor
unsigned long oldcnt[4]; // this is for the last measurement of the first sensor
int t = 100; // this is for measuring time
unsigned long last; // to store last meaurment time in milliseconds from starting the device

//assign names to sensors and leds this has to be sound iwth the pinout from controller
int S[] = {2, 3, 18, 19};
int L[] = {48, 46, 44, 42};
//int pair[] = {0, 1, 2, 3};
unsigned long hz[4];


void irq0() //this function counts the pulses from the first sensor
{
  cnt[0]++;
}
void irq1() //this function counts the pulses from the first sensor
{
  cnt[1]++;
}
void irq2() //this function counts the pulses from the first sensor
{
  cnt[2]++;
}
void irq3() //this function counts the pulses from the first sensor
{
  cnt[3]++;
}


///////////////////////////////////////////////////////////////////
//
// SETUP
//
void setup()
{
  Serial.begin(115200); // communication set to 115200
  Serial.println("START, Beginning of the FILE"); // First comment in the serial monitor
  Serial.println("S0, S1, S2, S3"); // First comment in the serial monitor
  pinMode(S[0], INPUT); // set the sensor0 pin to input
  pinMode(S[1], INPUT); // set the sensor0 pin to input
  pinMode(S[2], INPUT); // set the sensor0 pin to input
  pinMode(S[3], INPUT); // set the sensor0 pin to input
  pinMode(L[0], OUTPUT); // set the LED1 pin to output
  pinMode(L[1], OUTPUT); // set the LED1 pin to output
  pinMode(L[2], OUTPUT); // set the LED1 pin to output
  pinMode(L[3], OUTPUT); // set the LED1 pin to output
  digitalWrite(S[0], HIGH);
  digitalWrite(S[1], HIGH);
  digitalWrite(S[2], HIGH);
  digitalWrite(S[3], HIGH);
  
  
  attachInterrupt(0, irq0, RISING); // this function attach interrupt is here to consistently count pulses.
  attachInterrupt(1, irq1, RISING); // this function attach interrupt is here to consistently count pulses.
  attachInterrupt(2, irq2, RISING); // this function attach interrupt is here to consistently count pulses.
  attachInterrupt(3, irq3, RISING); // this function attach interrupt is here to consistently count pulses.
}



///////////////////////////////////////////////////////////////////
//
// MAIN LOOP
//
void loop()
{
  if (millis() - last >= 10000) { // if time from the last measurment is over 1 minute = run!
    last = millis();
    for (int i = 0; 1 < 4; ++i) {
      hz[i] = counter(i);
    }
    Serial.print(hz[0]);
    Serial.print(";");
    Serial.print(hz[1]);
    Serial.print(";");
    Serial.print(hz[2]);
    Serial.print(";");
    Serial.print(hz[3]);
    Serial.print("\n"); 
  }
}

unsigned long counter(int p){
  digitalWrite(L[p],HIGH);
  delay(50);
//  cli();//disable interrupts
//  cnt[p] = 0;
//  sei();//enable interrupts
//  delay(t);
//  cli();//disable interrupts
//  long result = cnt[p]*1000/t; // here we add the t variable to always get Hz.
//  sei();//enable interrupts
//  digitalWrite(L[p],LOW);
//  delay(50);
  Serial.print(p);
  Serial.print(",=-> ");
  Serial.print(cnt[p]);
  Serial.print(", ");
  hz[p] = cnt[p];
  delay(t);
  //Serial.print(t);
  //Serial.print(", ");
  hz[p] = cnt[p]-hz[p];
  //Serial.print(p);
  Serial.print(", ");
  Serial.print(hz[p]);
  Serial.print("\n");
  
  Serial.print(millis());
  delay(100);
  //return result;
}

// END OF FILE
