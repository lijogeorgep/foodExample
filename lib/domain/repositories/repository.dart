


import 'package:food_example/data/datasource/provider.dart';
import 'package:food_example/data/model/food.dart';

class Repository {
  Provider foodScreenProviders = Provider();

  Future<List<Food>> getFood() =>
      foodScreenProviders.getFood();
 
}
