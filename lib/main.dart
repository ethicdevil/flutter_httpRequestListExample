import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Http Request Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  String uri = 'https://randomuser.me/api/?results=15';
  List data;

  Future<String> makeRequest() async{
    var response =  
        await http.get(Uri.encodeFull(uri),
          headers: {"Accept" : "application/json"});
          
   
    setState(() {
        var extractData = json.decode(response.body);// jsonDecode(response.body);
        data =  extractData['results'];
    });
  
  }

  @override
  void initState(){
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Contact List'),

        ),
        body: new ListView.builder(
          itemCount: data ==null ? 0 : data.length,
          itemBuilder: (BuildContext context,i){
            return new ListTile(
              title:  new Text(data[i]["name"]["first"]),
              subtitle: new Text(data[i]["phone"]),
              leading: new CircleAvatar(
                backgroundImage: new NetworkImage(data[i]["picture"]["thumbnail"]),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (BuildContext context)=> 
                      new SecondPage(data[i])
                    )
                  );
              },
            );
          },
        ), 
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Profile")
      ),
      body: new Center(
        child: Container(
          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: NetworkImage(data["picture"]["large"]),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
            border: new Border.all(
              color: Colors.red,
              width: 4.0,
            )
          ),
        ),
      ),
    );
  }
}
