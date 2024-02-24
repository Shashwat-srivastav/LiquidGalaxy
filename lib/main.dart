// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Setting(),
    );
  }
}

class LiquidButtons extends StatefulWidget {
  var ip;
  var user;
  String pass;

  LiquidButtons({
    Key? key,
    required this.ip,
    required this.user,
    required this.pass,
  }) : super(key: key);


  static orbitBalloon(
    String cityImage, 
  ) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>About Data</name>
 <Style id="about_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <h1>Prayagraj</h1>
        <h1>Shashwat</h1>
        <img src="${cityImage}" alt="picture" width="300" height="200" />
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ab">
   <description>
   </description>
   <LookAt>
     <longitude>81.867004</longitude>
     <latitude>25.446940</latitude>
     <heading>0</heading>
     <tilt>0</tilt>
     <range>200</range>
   </LookAt>
   <styleUrl>#about_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>81.867004,25.446940,0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';

  @override
  State<LiquidButtons> createState() => _LiquidButtonsState();
}

class _LiquidButtonsState extends State<LiquidButtons> {
  

///-----------------------reboot function -----------------------------------------//
   Future<void> reboot() async {
   
  

    final client = SSHClient(
      await SSHSocket.connect(widget.ip.toString()
        // '192.168.56.101'
      , 22,
          timeout: const Duration(seconds: 5)),
      username: widget.user
      // 'lg'
      ,
      onPasswordRequest: () => widget.pass
      // 'lg'
      ,

    );
    print('hey');
   
    for(var i=3;i>=1;i--)
    {
       await client.run('/home/lg/bin/lg-locate');
        await client.run(
          'sshpass -p ${widget.pass} ssh -t lg$i "echo ${widget.pass} | sudo -S reboot"');
    }
    // 'sshpass -p ${'lg'} ssh -t lg$i "echo ${'lg'} | sudo -S reboot"'
  }

//---------------------------Move to home city function -----------------------------------/
   Future<void> move() async {
    print(widget.ip);
    print(widget.pass);
    print(widget.user);

    
    final client = SSHClient(
      await SSHSocket.connect(
          widget.ip.toString()
          // '192.168.56.101'
          ,
          22,
          timeout: const Duration(seconds: 5)),
      username: widget.user
      // 'lg'
      ,
      onPasswordRequest: () => widget.pass
      // 'lg'
      ,
    );
    print('hey');
    await client.run(
        "echo 'flytoview= <LookAt><longitude>81.867004</longitude><latitude>25.446940</latitude><range>200.57188054921561</range><tilt>0</tilt><heading>0</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>' > /tmp/query.txt");
  }

//--------------------------------------orbit on the home city---------------------------------------------//
   Future<void> connection() async {
   
     final client = SSHClient(
      await SSHSocket.connect(
          widget.ip.toString()
          // '192.168.56.101'
          ,
          22,
          timeout: const Duration(seconds: 5)),
      username: widget.user
      // 'lg'
      ,
      onPasswordRequest: () => widget.pass
      // 'lg'
      ,
    );

    print('hey');
    var j = 0;
    for (int i = 0; i <= 180; i += 17) {
      if (j == 360) {
        j = 0;
      }
      await client.run(
          'echo "flytoview= <LookAt><longitude>81.867004</longitude><latitude>25.446940</latitude><range>200.57188054921561</range><tilt>${j}</tilt><heading>${i}</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>" > /tmp/query.txt');
      j++;
      await Future.delayed(const Duration(milliseconds: 2000));
    }
    final uptime = await client.run('uptime');
    print(utf8.decode(uptime));
  }

//-------------------------------------display on the Rig ---------------------------------------------------/
  Future<void> onlgRig() async {
     final client = SSHClient(
      await SSHSocket.connect(
          widget.ip
          // '192.168.56.101'
          ,
          22,
          timeout: const Duration(seconds: 5)),
      username: widget.user
      // 'lg'
      ,
      onPasswordRequest: () => widget.pass
      // 'lg'
      ,
    );

    print('hey');

      String img='https://raw.githubusercontent.com/Shashwat-srivastav/pandaaasprofile/d91b6fd8b04ff17a87c66ee994d5fb16ee2a4f41/imageLG.png';
      // orbitBalloon(img, 'Allahabad')
    await  client.execute("echo '${LiquidButtons.orbitBalloon(img)}' > /var/www/html/kml/slave_1.kml"); 
     
     
      for (var i = 1; i <= 3; i++) {
        String search =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await client.run(
            'sshpass -p ${'lg'} ssh -t lg$i \'echo ${'lg'} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }



     for (var i = 1; i <= 3; i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await client.run(
            'sshpass -p ${'lg'} ssh -t lg$i \'echo ${'lg'} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await client.run(
            'sshpass -p ${'lg'} ssh -t lg$i \'echo ${'lg'} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
     
  }
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.amber,
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 1,
              child: TextButton(
                child: Text('reboot the lg (with a warning before)',
                    style: TextStyle(fontSize: 36)),
                onPressed: () {
                   reboot();
                },
              ),
            ).p(20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.amber,
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 1,
              child: TextButton(
                child: Text('move the lg to your home city',
                    style: TextStyle(fontSize: 36)),
                onPressed: () {
                   move();
                },
              ),
            ).p(20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.amber,
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 1,
              child: TextButton(
                child: Text('make an orbit upon arrival to your city',
                    style: TextStyle(fontSize: 36)),
                onPressed: () {
                   connection();
                },
              ),
            ).p(20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.amber,
              ),

              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 1,
              child: TextButton(
                child: Text(
                  ' City name and your name ',
                  style: TextStyle(fontSize: 36),
                ),
                onPressed: () {
                  onlgRig();
                },
              ),
            ).p(20)
          ],
        ),
      ),
    );
  }
}



class Setting extends StatefulWidget {
   Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String ip ='';

  String user ='';

  String pass='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
           onFieldSubmitted: (value) {
             ip=value;
           },
          ),
           TextFormField(
            onFieldSubmitted: (value) {
              user = value;
            },
          ),
           TextFormField(
            onFieldSubmitted: (value) {
              pass = value;
            },
          ),
          ElevatedButton(onPressed: (){
            Get.to( LiquidButtons(ip:ip,user: user,pass: pass));
            
           
          }, child: "submit".text.make())
        ],
      ),
    );
  }
}