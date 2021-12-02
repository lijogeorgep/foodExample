import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_example/bloc/fetch_state.dart';

import 'bloc/fetch_bloc.dart';
import 'bloc/fetch_event.dart';
import 'data/model/food.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String heading;
  FetchBloc fetchBloc;
  ValueNotifier<int> _counter = ValueNotifier<int>(0);
  @override
  void initState() {
    fetchBloc = FetchBloc();
    fetchBloc.add(FetchFoodEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder(
                  bloc: fetchBloc,
                  builder: (context, snapshot) {
                    print('state$snapshot');

                    if (snapshot is FetchLoadedState) {
                      return buildProductList(snapshot.foodScreen, context);
                    } else if (snapshot is FetchErrorState) {
                      return buildErrorUi(snapshot.message);
                    }
                    return showCircleProgress();
                  }),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: Icon(Icons.shopping_cart_rounded,

        ),
      ),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "No data found",
        ),
      ),
    );
  }

  Widget showCircleProgress({double size = 30}) => Align(
        alignment: Alignment.center,
        child: SizedBox(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );

  Widget buildProductList(List<Food> foodScreen, context) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: foodScreen.length,
      itemBuilder: (context, position) => Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Center(child: Text(foodScreen[position].restaurantName,style: TextStyle(fontSize: 28,color: Colors.white,letterSpacing: 3.0),))),
           SizedBox(height: 20,),
            ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount:foodScreen[position].tableMenuList.length,
                itemBuilder: (context, position2){
                  return Container(child: Column(
                    children: [
                      Text(foodScreen[position].tableMenuList[position2].menuCategory,style: TextStyle(color: Colors.blue,fontSize: 20),),
                      ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:foodScreen[position].tableMenuList[position2].categoryDishes.length,
                          itemBuilder: (context, position3){
                            return Column(

                              children: [
                                SizedBox(height: 10,),
                                Align(
                                  alignment:Alignment.topLeft,
                                    child: Text(foodScreen[position].tableMenuList[position2].categoryDishes[position3].dishName,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
                                SizedBox(height: 10,),
                                Align(
                                    alignment:Alignment.topLeft,
                                    child: Text(foodScreen[position].tableMenuList[position2].categoryDishes[position3].dishDescription,style: TextStyle(color: Colors.black38),)),
                              SizedBox(height: 10,),
                                Row(

                                  children: [
                                    Text('calories'+' '+foodScreen[position].tableMenuList[position2].categoryDishes[position3].dishCalories.toString(),style: TextStyle(color: Colors.black38),),
                                    Text('\$ '+foodScreen[position].tableMenuList[position2].categoryDishes[position3].dishPrice.toString()),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                                SizedBox(height: 10,),
                                Align(
                                    alignment:Alignment.topLeft,
                                    child: foodScreen[position].tableMenuList[position2].categoryDishes[position3].dishAvailability? Text('available',style: TextStyle(color: Colors.green),):Text('finished',style: TextStyle(color: Colors.redAccent))),

                                Align(
                                  alignment: Alignment.topRight,
                                  child:foodScreen[position].tableMenuList[position2].categoryDishes[position3].dishAvailability?
                                  Container(
                                    margin: const EdgeInsets.only(top: 12, bottom: 12),
                                    width: 120,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                       /* IconButton(
                                          icon: const Icon(
                                            Icons.remove_rounded,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {

                                            if (_counter.value <= 0) {
                                              print("nop");
                                            } else {
                                              _counter.value--;
                                            }
                                          },
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: _counter,
                                          builder: (context, value, child) {
                                            return Text(
                                              '$value',
                                              style: const TextStyle(color: Colors.white),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            //foodScreen[position].tableMenuList[position2].categoryDishes[position3]
                                            _counter.value++;

                                          },
                                        ),*/
                                        IconButton(
                                          icon: new Icon(Icons.remove,
                                              color: Colors.white),
                                          onPressed: foodScreen[
                                          position]
                                              ?.tableMenuList[
                                          position2]
                                              ?.categoryDishes[
                                          position3]
                                              .cartedItem >
                                              0
                                              ? () {
                                            setState(() {
                                              foodScreen[
                                              position]
                                                  ?.tableMenuList[
                                              position2]
                                                  ?.categoryDishes[
                                              position3]
                                                  .cartedItem--;
                                              if (foodScreen[
                                              position]
                                                  ?.tableMenuList[
                                              position2]
                                                  ?.categoryDishes[
                                              position3]
                                                  .cartedItem ==
                                                  0) {}
                                            });
                                          }
                                              : null,
                                        ),
                                        Text(
                                            foodScreen[position]
                                                ?.tableMenuList[position2]
                                                ?.categoryDishes[position3]
                                                .cartedItem
                                                .toString(),
                                            style:TextStyle(color: Colors.white)),
                                        IconButton(
                                            icon: new Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                foodScreen[position]
                                                    ?.tableMenuList[
                                                position2]
                                                    ?.categoryDishes[
                                                position3]
                                                    .cartedItem++;
                                              });
                                            })
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ):Container(),
                                ),
                                Divider(),
                              ],
                            );
                          },
                      ),
                    ],
                  ));
                }
                 ),

            const Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
