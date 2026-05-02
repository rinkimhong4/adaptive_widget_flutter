import 'package:adaptive_widgeet/%20graphic_charts/pages/animation.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/bigdata.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/combined_polygon_custom.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/crosshair.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/echarts.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/interaction_stream_dynamic.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/interval.dart';
import 'package:adaptive_widgeet/%20graphic_charts/pages/line_area_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text("animation"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnimationPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("BigdataPage"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BigdataPage()),
                );
              },
            ),
            ListTile(
              title: Text("TriangleShape"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CombinedPolygonCustomPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("CrosshairPage"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrosshairPage()),
                );
              },
            ),
            ListTile(
              title: Text("EchartsPage"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EchartsPage()),
                );
              },
            ),
            ListTile(
              title: Text("InteractionStreamDynamicPage"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InteractionStreamDynamicPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("IntervalPage"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IntervalPage()),
                );
              },
            ),
            ListTile(
              title: Text("LineAreaPointPage"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LineAreaPointPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
