import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:josenian_quiri/screens/homepage.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff02C636),
        body: PageView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 250,
                ),
                Center(
                  child: Container(
                    width: 250.0,
                    height: 250.0,
                    decoration: BoxDecoration(
                      color: Color(0xff02C636),
                      shape: BoxShape.rectangle,
                      image: const DecorationImage(
                        image: AssetImage('assets/jquiri.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MyHomePage(),
          ],
        ),
      ),
    );
  }
}
