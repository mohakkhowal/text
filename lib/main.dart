import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> data = [];
  @override
  void initState(){
    getData();
    super.initState();
  }
  void getData() async {
    try {
      final response = await Dio().get('https://jamesclear.com/the-downside-of-being-effective');
      if (response.statusCode == 200) {
        try {
          var document = parser.parse(response.data);
          var elements = document.querySelectorAll('body *');
          for (var x in elements[0].text.split('\n')) {
            if (x.trim().length > 15) {
              data.add(x.trim());
            }
          }
          setState(() {
            print(data.length);
          });
          // print(elements[0].text.split('\n'));
          // print(elements[0].innerHtml.trim()[0]=='<');
          // for(var x in elements){
          //   if(x.innerHtml.trim().isNotEmpty  && x.innerHtml.trim()[0]!='<'){
          //     print(x.innerHtml.trim());
          //   }
          // }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: Center(
                  child: Text(data[index]),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: data.length),
      ),
    );
  }
}
