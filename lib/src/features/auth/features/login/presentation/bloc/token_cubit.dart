import 'package:bloc/bloc.dart';
import 'package:travel_ease_app/src/core/app/data/datasources/local_datasource.dart';
import 'package:travel_ease_app/src/core/utils/constants.dart';
import 'package:travel_ease_app/src/features/auth/core/data/models/token_model.dart';

class TokenCubit extends Cubit<String?> {
  final LocalDataSource localDataSource;

  TokenCubit({required this.localDataSource}) : super(null);

  void getToken(String? token) {
    emit(token);
  }

  void checkToken() {
    if (localDataSource.has(LocalKey.tokenKey)) {
      final cacheData = localDataSource.get(LocalKey.tokenKey);
      final tokenModel = TokenModel.fromJson(cacheData);

      emit(tokenModel.token);
      return;
    }

    emit(null);
  }
}
