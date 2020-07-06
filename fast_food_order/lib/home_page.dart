import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'restaurant_page.dart';
import 'carousel.dart';
import 'models/restaurant.dart';
import 'controls.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Restaurant> restaurants = Restaurant.all;
  Restaurant currentRestaurant = Restaurant.all[0];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Container(
      color: currentRestaurant.color,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SafeArea(
                bottom: false,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(18.0)),
                  child: Text(
                    "ASPS → Work",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: SKCarousel(
                  options: CarouselOptions(
                      // height: MediaQuery.of(context).size.height,
                      // aspectRatio: 0.7,
                      enableInfiniteScroll: false,
                      onPageChanged: _onPageChanged,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      initialPage: 0),
                  items: restaurants.map((rest) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ContentCard(restaurant: rest);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(
                      //     builder: (context) =>
                      //         RestaurantPage(currentRestaurant),
                      //     fullscreenDialog: true),
                      PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                            return RestaurantPage(currentRestaurant);
                          },
                          transitionsBuilder:
                              (context, animation1, animation2, child) {
                            return FadeTransition(
                              opacity: animation1,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 250),
                          fullscreenDialog: true),
                    );
                  },
                  color: Colors.black,
                  textColor: Colors.white,
                  child:
                      Text("Order from here", style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    // print("Page changed: $index reason: $reason");
    setState(() {
      currentRestaurant = restaurants[index];
    });
  }
}

class ContentCard extends StatelessWidget {
  ContentCard({this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    var descStyle = TextStyle(
      color: Colors.black54,
      fontSize: 13,
    );

    return Column(
      children: <Widget>[
        Spacer(),
        Image(
          image: AssetImage('images/' + restaurant.logo + '.png'),
          height: 100,
        ),
        Spacer(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 4 / 3,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              )),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
            child: Column(children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                    // child: Center(
                    child: Hero(
                      tag: '${restaurant.id}.photo',
                      child: Image(
                        image:
                            AssetImage('images/' + restaurant.photo + '.png'),
                      ),
                    ),
                    // ),
                    decoration: new BoxDecoration(
                        color: restaurant.color,
                        borderRadius: BorderRadius.circular(18.0))),
              ),
              SizedBox(
                height: 24,
              ),
              Hero(
                tag: '${restaurant.id}.name',
                child: Text(
                  restaurant.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Hero(
                tag: '${restaurant.id}.info',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 14,
                    ),
                    Text(
                      restaurant.rating.toStringAsPrecision(2),
                      style: descStyle,
                    ),
                    CircleContainer(
                      size: 3,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Text(
                      restaurant.description,
                      style: descStyle,
                    ),
                    CircleContainer(
                      size: 3,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Text(
                      restaurant.priceRangeString(),
                      style: descStyle,
                    )
                  ],
                ),
              ),
              Hero(
                tag: '${restaurant.id}.orderTime',
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(18.0)),
                  child: Text(
                    restaurant.orderTimeString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
