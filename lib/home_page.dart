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
            Text(foodScreen[position].restaurantName,style: TextStyle(fontSize: 28,color: Colors.green,letterSpacing: 3.0),),
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