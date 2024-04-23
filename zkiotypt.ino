#include <ESP8266WiFi.h>
 
#define AP_SSID "M0YuE" //这里改成你的wifi名字
#define AP_PSW  "987654302"//这里改成你的wifi密码
 
const uint16_t port =6666;
const char * host = "192.168.43.136"; // ip or dns
WiFiClient client;//创建一个tcp client连接
//led长脚接正极 16脚0红灯 12脚0绿灯 13脚0蓝灯
// 15脚1则继电器开 0则关
//14脚ds18b20
//红灯开 0000 01 aaaa 红灯关 0000 00 aaaa
//绿灯开 0001 01 aaaa 绿灯关 0001 00 aaaa
//蓝灯开 0002 01 aaaa 蓝灯关 0002 00 aaaa
//红灯查询 0003 00 aaaa 返回 0003 0[0/1] aaaa
//绿灯查询 0004 00 aaaa 返回 0004 0[0/1] aaaa
//蓝灯查询 0005 00 aaaa 返回 0005 0[0/1] aaaa
//温度查询 0006 00 aaaa 返回 0006 [00000000] aaaa
//继电器开 0007 01 aaaa 继电器关 0007 00 aaaa
//继电器查询 0008 00 aaaa 返回 0008 0[0/1] aaaa
int red = 16,green = 12,blue = 13,redStatu = 0,greenStatu = 0,blueStatu = 0;
int jidian = 15,jidianStatu = 0,infrared=0,smoke=0;

//下为传感器计数器定义
int RLEDstatu = -1; //Led灯计数器
int InfStatu = -1;   //红外传感器计数器
int SmokeStatu = -1; //烟雾传感器计数器

int DSPIN = 14;

// test 改变测试用变量数值用于服务器端接收数据检测
int clientIntValue = 0;

void setup() {
  pinMode(red,OUTPUT);
  digitalWrite(red,HIGH);
  pinMode(green,OUTPUT);
  digitalWrite(green,HIGH);
  pinMode(blue,OUTPUT);
  digitalWrite(blue,HIGH);
  pinMode(jidian,OUTPUT);
  digitalWrite(jidian,LOW);

  //TEst
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(D0,INPUT);
  pinMode(A0,INPUT);

  Serial.begin(115200);
  delay(1000);
  WiFi.mode(WIFI_STA);    //STA模式
  WiFi.begin(AP_SSID,AP_PSW); //登陆WIFI
  Serial.println("正在登陆WIFI... ");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("");
  Serial.println("WiFi连接成功");
  Serial.print("IP地址是: ");
  Serial.println(WiFi.localIP());
  delay(500);
  Serial.print("连接到 ");
  Serial.println(host);
  if (!client.connect(host, port)) {
    //client.connect(host, port)   连接TCP server端,连接成功返回True
    Serial.println("TCP server端连接失败");
    Serial.println("请等待5秒后重新连接...");
    delay(5000);
    return;
  }
 Serial.println("TCP server端连接成功");
 client.print("@acbc@");//aabc aabd
}
void ctlRed(int statu){
  if(statu == 1){
    digitalWrite(red,LOW);
    digitalWrite(green,HIGH);
    digitalWrite(blue,HIGH);
    redStatu = 1;
    greenStatu = 0;
    blueStatu = 0;
  }else{
      if(redStatu != 0){
        digitalWrite(red,HIGH);
        redStatu = 0;
      }
  }
}
void ctlGreen(int statu){
  if(statu == 1){
    digitalWrite(green,LOW);
    digitalWrite(red,HIGH);
    digitalWrite(blue,HIGH);
    greenStatu = 1;
    redStatu = 0;
    blueStatu = 0;
  }else{
      if(greenStatu != 0){
        digitalWrite(green,HIGH);
        greenStatu = 0;
      }
  }
}
void ctlBlue(int statu){
  if(statu == 1){
    digitalWrite(blue,LOW);
    digitalWrite(green,HIGH);
    digitalWrite(red,HIGH);
    blueStatu = 1;
    greenStatu = 0;
    redStatu = 0;
  }else{
      if(blueStatu != 0){
        digitalWrite(blue,HIGH);
        blueStatu = 0;
      }
  }
}
void loop() {

  GetInfrared();
  GetSmoke();    //此处调用函数为了能够在串口查看并测试数据


   clientIntValue += 2;
   // 发送请求
   wifiClientRequest();

  if(client.available()){
    int a1 = client.read();
    int a2 = client.read();
    int a3 = client.read();
    int a4 = client.read();
    int a5 = client.read();
    if(a1 == 0 && a2 == 0 && a4 == 170 && a5 == 170){//红灯控制             // 00 00 0[1/0] [开/关] 灯
      TurnRLED(a3);
      char chr[5] = {(char)a1,(char)a2,(char)a3,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 1 && a4 == 170 && a5 == 170){                // 00 01 01 继电器
      ctlGreen(a3);
      char chr[5] = {(char)a1,(char)a2,(char)a3,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 2 && a4 == 170 && a5 == 170){                // 00 02 01
      ctlBlue(a3);
      char chr[5] = {(char)a1,(char)a2,(char)a3,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 3 && a4 == 170 && a5 == 170){                // 00 03 01 LED情况
      char chr[5] = {(char)a1,(char)a2,(char)RLEDstatu,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 4 && a4 == 170 && a5 == 170){                // 00 04 01 红外传感器
      char chr[5] = {(char)a1,(char)a2,(char)InfStatu,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 5 && a4 == 170 && a5 == 170){                // 00 05 01 烟雾传感器
      char chr[5] = {(char)a1,(char)a2,(char)SmokeStatu,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 6 && a4 == 170 && a5 == 170){
      float temp = TempRead();
      temp *= 0.0625;//转换精度为0.0625/LSB
      unsigned char sa[4];
      floatToByteArr(temp,sa);
      char chr[8] = {(char)a1,(char)a2,sa[0],sa[1],sa[2],sa[3],(char)a4,(char)a5};
      client.write(chr,8);
    }else if(a1 == 0 && a2 == 7 && a4 == 170 && a5 == 170){
      if(a3 == 1){
          digitalWrite(jidian,HIGH);
          jidianStatu = 1;
      }else{
          digitalWrite(jidian,LOW);
          jidianStatu = 0;
      }
      char chr[5] = {(char)a1,(char)a2,(char)jidianStatu,(char)a4,(char)a5};
      client.write(chr,5);
    }else if(a1 == 0 && a2 == 8 && a4 == 170 && a5 == 170){
      char chr[5] = {(char)a1,(char)a2,(char)jidianStatu,(char)a4,(char)a5};
      client.write(chr,5);
    }
  }
}
void floatToByteArr(float num,unsigned char * sa){
  unsigned int *ii = (unsigned int *)&num;
  int temp = *ii;
  char s[8];
  int index = 0;
  while(temp > 16){
    s[index++] = temp % 16;
    temp /= 16;
  }
  s[index] = temp;
  index = 0;
  for(int i = 7;i >= 0;i -= 2){
    int tem = s[i] * 16 + s[i - 1];
    sa[index++] = tem; // 65  212
  }
}
boolean DS18B20_Init()
{
  pinMode(DSPIN, OUTPUT);
  digitalWrite(DSPIN, HIGH);
  delayMicroseconds(5);
  digitalWrite(DSPIN, LOW);
  delayMicroseconds(750);//480-960
  digitalWrite(DSPIN, HIGH);
  pinMode(DSPIN, INPUT);
  int t = 0;
  while(digitalRead(DSPIN))
  {
    t++;
    if(t > 60) return false;
    delayMicroseconds(1);
  }
  t = 480 - t;
  pinMode(DSPIN, OUTPUT);
  delayMicroseconds(t);
  digitalWrite(DSPIN, HIGH);
  return true;
}

void DS18B20_Write(byte data)
{
  pinMode(DSPIN, OUTPUT);
  for(int i=0; i<8; i++)
  {
    digitalWrite(DSPIN, LOW);
    delayMicroseconds(10);
    if(data & 1) digitalWrite(DSPIN, HIGH);
    else digitalWrite(DSPIN, LOW);
    data >>= 1;
    delayMicroseconds(50);
    digitalWrite(DSPIN, HIGH);
  }
}

byte DS18B20_Read()
{
  pinMode(DSPIN, OUTPUT);
  digitalWrite(DSPIN, HIGH);
  delayMicroseconds(2);
  byte data = 0;
  for(int i=0; i<8; i++)
  {
    digitalWrite(DSPIN, LOW);
    delayMicroseconds(1);
    digitalWrite(DSPIN, HIGH);
    pinMode(DSPIN, INPUT);
    delayMicroseconds(5);
    data >>= 1;
    if(digitalRead(DSPIN)) data |= 0x80;
    delayMicroseconds(55);
    pinMode(DSPIN, OUTPUT);
    digitalWrite(DSPIN, HIGH);
  }
  return data;
}

int TempRead()
{
  if(!DS18B20_Init()) return 0;
  DS18B20_Write(0xCC);//发跳过ROM命令
  DS18B20_Write(0x44);//发读开始转换命令
  if(!DS18B20_Init()) return 0;
  DS18B20_Write(0xCC);//发跳过ROM命令
  DS18B20_Write(0xBE);//读寄存器，共九字节，前两字节为转换值
  int temp = DS18B20_Read();//低字节
  temp |= DS18B20_Read() << 8;//高字节
  return temp;
}

void TurnRLED(int statu){   //LED函数
  if(statu == 1) {
    digitalWrite(LED_BUILTIN, LOW);
    RLEDstatu = 1;   //指令为开灯 查询指令为1
  }
  else if (statu == 0){
    digitalWrite(LED_BUILTIN, HIGH);
    RLEDstatu = 0;   //只要指令第六位非1 就将LED查询指令置0
  }
}

void GetInfrared(){    //HC-SR501红外传感器
  infrared = analogRead(D0);       //infrared是D0上读取的数值
  Serial.print("infrared is:");
  Serial.println(infrared);
  if(infrared > 600){
    InfStatu = 1;     //如果红外传感器测得的值大于600，那么红外计数器为1，上传服务器；
    //buzzer();     //蜂鸣器
  }
  else InfStatu = 0;  //如果红外传感器测值没有大于600，那么红外计数器为0，上传服务器；
}

int GetSmoke(){
  smoke = analogRead(A0);
  Serial.print("Smoke is :");
  Serial.println(smoke);
  if(smoke>300){
    SmokeStatu = 1;     //如果烟雾传感器测得的值大于600，那么烟雾计数器为1，上传服务器；
    //buzzer();         //蜂鸣器
  }
  else SmokeStatu = 0;  //如果烟雾传感器测值没有大于600，那么烟雾计数器为0，上传服务器；

  return smoke;
}

void wifiClientRequest(){
//  WiFiClient client;

  // 将需要发送的数据信息放入客户端请求
  String url = "/smoke?int=" + String(clientIntValue);

  // 建立字符串，用于HTTP请求
  String httpRequest =  String("GET ") + url + " HTTP/1.1\r\n" +
                        "Host: " + host + "\r\n" +
                        "Connection: close\r\n" +
                        "\r\n";

  Serial.print("Connecting to ");
  Serial.print(host);

  if (client.connect(host, port)) {  //如果连接失败则串口输出信息告知用户然后返回loop
    Serial.println(" Sucess");

    client.print(httpRequest);          // 向服务器发送HTTP请求
    Serial.println("Sending request: ");// 通过串口输出HTTP请求信息内容以便查阅
    Serial.println(httpRequest);
  } else{
    Serial.println(" failed");
  }

  client.stop();
}

//void buzzer(){     //蜂鸣器
//  int frequency = 1050; //以Hz为单位指定
//  int buzzPin = 2; //设置 蜂鸣器引脚  2-> D4
//  int timeOn = 1000; //以毫秒为单位指定
//  int timeOff = 1000; //以毫秒为单位指定
//
//   tone (buzzPin, frequency);
//   delay (timeOn);       
//   noTone (buzzPin);
//   delay (timeOff);
//}