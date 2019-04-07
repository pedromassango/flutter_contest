import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: Home());
}
class Home extends StatefulWidget {
  @override
  State createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 56),
          ),
          Container(height: 56, width: double.maxFinite,
            decoration: BoxDecoration(color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]
            ),
          ),
          PaperMenu(),
        ],
      )
    );
  }
}
class PaperMenu extends StatefulWidget {
  @override
  State createState() => _PaperMenuState();
}

class _PaperMenuState extends State<PaperMenu> with SingleTickerProviderStateMixin{
  Animation<Offset> radAnim;
  Animation colorAnim;
  AnimationController controller;

  String title = 'PAPER';
  List<String> items = List.generate(8, (i)=> 'PAGE ${i+1}');

  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    colorAnim = ColorTween(begin: Colors.blue, end: Colors.white)
        .animate(CurvedAnimation( parent: controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    radAnim = Tween<Offset>( begin: Offset(0, 0), end: Offset(size.width, size.height)
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    return AnimatedBuilder(
      animation: controller, builder: (context, child) {
        return Stack( children: <Widget>[
            ClipPath( clipper: Clipper(radAnim.value),
              child: Container(
                height: size.height,
                padding: EdgeInsets.only(top: 65),
                color: Colors.blue,
                child: ListView.builder(itemCount: items.length,
                  itemBuilder: (context, i) => ListTile(
                    onTap: ()=> setState((){
                      title = items[i];
                      controller.reverse();
                    }),
                    title: Text(items[i], style: TextStyle(
                      color: Colors.white.withOpacity(0.7)),
                    ),
                  )
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(padding: const EdgeInsets.only(top: 16),
                child: Text(title.toUpperCase(), style: TextStyle(
                    color: colorAnim.value, fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
                ),
              ),
            ),
            Align( alignment: Alignment.topRight, child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: Icon(Icons.search, color: colorAnim.value,),
              ),
            ),
            GestureDetector(
              onTap: () => controller.isCompleted ? controller.reverse() : controller.forward(),
              child: Padding( padding: EdgeInsets.all(20.0),
                child: Icon(controller.isDismissed ? Icons.menu : Icons.close, color: colorAnim.value,),
              ),
            )
          ],
        );
      },
    );
  }
}
class Clipper extends CustomClipper<Path>{
  final Offset percent;
  Clipper(this.percent);

  @override
  Path getClip(Size size) {
    final p = Path();
    p.addOval(Rect.fromCircle(center: Offset(16*2.0, 16*2.0), radius: percent.dx * percent.dy / 300));
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => true;
}