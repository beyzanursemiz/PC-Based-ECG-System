#define FILTER_SIZE 10
#define THRESHOLD 2000        
int filterBuffer[FILTER_SIZE];
int filterIndex = 0;
unsigned long lastBeatTime = 0;
int lastHeartRate = 0;
void setup() {
  Serial.begin(115200);       
  analogReadResolution(12);   
}
int smoothADC(int pin) {
  filterBuffer[filterIndex] = analogRead(pin);
  filterIndex = (filterIndex + 1) % FILTER_SIZE;
  int sum = 0;
  for (int i = 0; i < FILTER_SIZE; i++) {
    sum += filterBuffer[i];
  }
  return sum / FILTER_SIZE;
}
void loop() {
  int ekgValue = smoothADC(PA0); 
  unsigned long currentTime = millis();
  static bool beatDetected = false;
  if (ekgValue > THRESHOLD && !beatDetected) {
    if (currentTime - lastBeatTime > 300) {  
      lastHeartRate = 60000 / (currentTime - lastBeatTime);
      lastBeatTime = currentTime; }
beatDetected = true;
  } 
  else if (ekgValue < THRESHOLD - 100) {
    beatDetected = false; 
  }
  Serial.print(ekgValue);
  Serial.print(",");
  Serial.println(lastHeartRate);

  delayMicroseconds(3000); 
}