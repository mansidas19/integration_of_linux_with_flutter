import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
var webdata,cmd;
class MyApp extends StatelessWidget {
 var fsconnect=FirebaseFirestore.instance;

 mycmd(mycmd) async {
  var url="http://192.168.99.104/cgi-bin/web.py?x=${mycmd}";
  var r = await http.get(url);
  webdata = r.body;
  print(webdata);
}
  @override
  Widget build(BuildContext context) {
    var fs = FirebaseFirestore.instance;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('LINUX APP',style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.redAccent),),
          backgroundColor: Colors.greenAccent,
        ),
        body: Container(
          margin: EdgeInsets.all(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
      topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50)
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.greenAccent.withOpacity(1),
        spreadRadius: 30,
        blurRadius: 20,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
          ),
          child: Column(
            children: <Widget>[
              TextField(
                    onChanged: (value){
                      cmd = value;
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Write your desired command",
                      prefixIcon: Icon(Icons.arrow_forward)
                    ),
                  ),
              FlatButton(
                    onPressed: (){
                      mycmd(cmd);
                    },
                    child: Text('ENTER',style: TextStyle(fontSize: 20,),),
                    color: Colors.blue.shade50,
                  ),
              RaisedButton(
                child: Text('SEND DATA'),
                color: Colors.redAccent,
                onPressed: (){
                  fsconnect.collection("command output").add({
                    'command':'${webdata}'
                  });
                  print('send..');
                },
              ),
              StreamBuilder<QuerySnapshot>(
                builder: (context, snapshot) {
                  print('new data comes');

                  var msg = snapshot.data.docs;

                  List<Widget> y = [];
                  for (var d in msg) {
                    var msgText = d.data()['command'];
                    var msgWidget = Text("$msgText");

                    y.add(msgWidget);
                  }

                  print(y);

                  return Container(
                    child: Column(
                      children: y,
                    ),
                  );
                },
                stream: fs.collection("command output").snapshots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
