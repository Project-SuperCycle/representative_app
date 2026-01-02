import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:supercycle/core/errors/failures.dart';
import 'package:supercycle/core/models/social_auth_request_model.dart'
    show SocialAuthRequestModel;
import 'package:supercycle/core/models/social_auth_response_model.dart'
    show SocialAuthResponseModel;
import 'package:supercycle/core/repos/social_auth_repo.dart';
import 'package:supercycle/core/services/api_endpoints.dart' show ApiEndpoints;
import 'package:supercycle/core/services/api_services.dart';
import 'package:supercycle/core/services/storage_services.dart';

class SocialAuthRepoImp implements SocialAuthRepo {
  final ApiServices apiServices;

  SocialAuthRepoImp({required this.apiServices});

  @override
  Future<Either<Failure, SocialAuthResponseModel>> socialSignup({
    required SocialAuthRequestModel credentials,
  }) async {
    // TODO: implement socialSignup
    try {
      final response = await apiServices.post(
        endPoint: ApiEndpoints.socialLogin,
        data: credentials.toJson(),
      );

      if (response['status'] == 201) {
        SocialAuthResponseModel socialAuth = SocialAuthResponseModel.fromJson({
          "status": response['status'],
          "message": response['message'],
          "token": response['token'],
        });
        StorageServices.storeData('token', socialAuth.token);
        return right(socialAuth);
      } else if (response['status'] == 200) {
        SocialAuthResponseModel socialAuth = SocialAuthResponseModel.fromJson({
          "status": response['status'],
          "message": response['message'],
          "token": response['token'],
          "user": response['data'],
        });
        StorageServices.storeData('user', socialAuth.user);
        StorageServices.storeData('token', socialAuth.token);
        return right(socialAuth);
      }
      SocialAuthResponseModel socialAuth = SocialAuthResponseModel.fromJson({
        "status": response['status'],
        "message": response['message'],
      });

      return right(socialAuth);
    } on DioException catch (dioError) {
      return left(ServerFailure.fromDioError(dioError));
    } on FormatException catch (formatError) {
      return left(
        ServerFailure(
          formatError.toString(),
          422, // Unprocessable Entity
        ),
      );
    } on TypeError catch (typeError) {
      return left(
        ServerFailure(
          'Data parsing error: ${typeError.toString()}',
          422, // Unprocessable Entity
        ),
      );
    } catch (e) {
      return left(
        ServerFailure(
          'Unexpected error occurred: ${e.toString()}',
          520, // Unknown Error
        ),
      );
    }
  }
}
