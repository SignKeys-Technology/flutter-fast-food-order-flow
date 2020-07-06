import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'models/restaurant.dart';
import 'controls.dart';
import 'models/food_category.dart';
import 'models/meal.dart';

class RestaurantPage extends StatefulWidget {
  RestaurantPage(this.restaurant);

  final Restaurant restaurant;
  @override
  _RestaurantPageState createState() => _RestaurantPageState(restaurant);
}

class _RestaurantPageState extends State<RestaurantPage>
    with SingleTickerProviderStateMixin {
  _RestaurantPageState(this.restaurant);
  AnimationController _expandController;
  Animation<double> _animation;

  final _categoriesScrollController = ScrollController();
  final ScrollController _mealsScrollController = ScrollController();
  void Function() _mealsScrollListener;
  List<Meal> _meals;
  FoodCategory _currentCategory;

  final Restaurant restaurant;
  List<ListItem<FoodCategory>> categories =
      FoodCategory.all.map((e) => ListItem<FoodCategory>(e)).toList();

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    // _expandController.forward();
  }

  ///Setting up the animation
  void prepareAnimations() {
    _mealsScrollListener = () {
      if (_mealsScrollController.offset > 100) {
        _mealsScrollController.removeListener(_mealsScrollListener);
        _expandController.reverse();
      }
    };
    _mealsScrollController.addListener(_mealsScrollListener);
    _expandController = AnimationController(
        vsync: this,
        value: 1.0,
        duration: Duration(milliseconds: 1),
        reverseDuration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var descStyle = TextStyle(
      color: Colors.black54,
      fontSize: 13,
    );
    var selectedCategory = categories.firstWhere(
        (element) => element.isSelected,
        orElse: () => categories[0]);
    selectedCategory.isSelected = true;
    _currentCategory = selectedCategory.data;
    _meals = Meal.getMeals(_currentCategory);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: restaurant.color,
          elevation: 0,
          leading: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.chevron_left, size: 32),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  //TODO
                });
              },
            ),
          ]),
      body: Container(
        color: restaurant.color,
        child: Column(
          children: <Widget>[
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _animation,
              child: Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: '${restaurant.id}.photo',
                  child: Image(
                    image: AssetImage('images/' + restaurant.photo + '.png'),
                    height: 100,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                          controller: _categoriesScrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: _buildCategoryTile),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _currentCategory.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          controller: _mealsScrollController,
                          itemCount: _meals.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 8, crossAxisCount: 2),
                          itemBuilder: _buildMealCard),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, int index) {
    // var imgSize = MediaQuery.of(context).size.width - 20;
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Flexible(
              child: Align(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Image(
                    image: AssetImage('images/' + _meals[index].photo + '.png'),
                    // width: imgSize,
                    // height: imgSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              _meals[index].title,
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
            SizedBox(height: 4),
            Text(
              'AED: ${_meals[index].AED}',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ]),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 26,
              width: 26,
              child: RawMaterialButton(
                onPressed: () {
                  //TODO
                },
                elevation: 1.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.add,
                  size: 16.0,
                ),
                padding: EdgeInsets.zero,
                shape: CircleBorder(),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, int index) {
    var key = new GlobalKey();
    return GestureDetector(
      key: key,
      onTap: () {
        setState(() {
          for (int i = 0; i < categories.length; i++) {
            categories[i].isSelected = i == index;
          }
          _currentCategory = categories[index].data;
          _meals = Meal.getMeals(_currentCategory);
        });
        // Scrollable.ensureVisible(key.currentContext);
        final RenderBox renderBox = key.currentContext.findRenderObject();
        // var position = renderBox.localToGlobal(Offset.zero);
        var vp = RenderAbstractViewport.of(renderBox);
        // Get the Scrollable state (in order to retrieve its offset)
        ScrollableState scrollableState = Scrollable.of(context);
        assert(scrollableState != null);

        // Get its offset
        ScrollPosition position = scrollableState.position;
        // double alignment;
        double moved = _categoriesScrollController.offset;
        var otr0 = vp.getOffsetToReveal(renderBox, 0.0).offset;
        var otr1 = vp.getOffsetToReveal(renderBox, 1.0).offset;
        if (position.pixels > otr0 - 20) {
          moved = otr0 - 20;
        } else if (position.pixels < otr1 + 20) {
          moved = otr1 + 20;
        }
        moved =
            max(min(moved, position.extentAfter + position.extentBefore), 0);
        if (moved != _categoriesScrollController.offset) {
          _categoriesScrollController.animateTo(moved,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn);
        }
      },
      child: SizedBox(
        width: 90,
        height: 120,
        child: CategoryCard(
          categories[index],
          selectionColor: restaurant.color,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }
}

class CategoryCard extends StatefulWidget {
  CategoryCard(this.item, {this.selectionColor});

  final ListItem<FoodCategory> item;
  final Color selectionColor;

  @override
  _CategoryCardState createState() =>
      _CategoryCardState(item, selectionColor: selectionColor);
}

class _CategoryCardState extends State<CategoryCard> {
  _CategoryCardState(this.item, {this.selectionColor});

  final ListItem<FoodCategory> item;
  final Color selectionColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: item.isSelected ? selectionColor : Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Image(
                image: AssetImage('images/' + item.data.photo + '.png'),
                width: 60,
                height: 60,
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              child: Center(
                child: Text(
                  item.data.title,
                  style: TextStyle(
                    color: item.isSelected ? Colors.white : Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
