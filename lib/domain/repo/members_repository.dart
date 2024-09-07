import 'dart:async';

import 'package:familyai/di/service_locator.dart';
import 'package:familyai/domain/repo/api_repository.dart';
import 'package:familyai/domain/repo/user_repository.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
class MembersRepository{
  final UserRepository _userRepository = getIt();
  final ApiRepository _apiRepository = getIt();
  final Logger _logger = getIt();
  final memberRefreshStream = StreamController<dynamic>.broadcast();
  Future<bool> createMember(String firstName, String lastName, String email, dynamic topic, dynamic role) async{
    final ret = await _apiRepository.createMember(firstName,lastName,email,topic,role);
    if (ret){
      memberRefreshStream.add(Jiffy.now());
    }
    return ret;
  }
  Stream<List<dynamic>> listen() {

    return CombineLatestStream.combine2(_userRepository.user(), memberRefreshStream.stream.startWith(0), (a,b){
      _logger.d("[Members] got new combine");
      return a;
    }).asyncMap((user)async {
      _logger.d("[Members] got new user");
      if (user == null){
        return [];
      } else {
        return await _apiRepository.members();
      }
    });

  }
}