

import 'package:food_example/config/serveraddress.dart';
import 'package:food_example/data/model/food.dart';
import 'package:food_example/domain/entities/app_exceptions.dart';
import 'package:food_example/domain/entities/rest_api.dart';

class Provider {
  Future<List<Food>> getFood() async {

    try {
      var res = await RestAPI().get(ServerAddress.foodList);

      return foodFromJson(res);
    } on RestException catch (e) {
      throw e.message;
    }
  }

}
