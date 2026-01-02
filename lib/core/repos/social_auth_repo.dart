import 'package:dartz/dartz.dart' show Either;
import 'package:supercycle/core/errors/failures.dart' show Failure;
import 'package:supercycle/core/models/social_auth_request_model.dart';
import 'package:supercycle/core/models/social_auth_response_model.dart';

abstract class SocialAuthRepo {
  Future<Either<Failure, SocialAuthResponseModel>> socialSignup({
    required SocialAuthRequestModel credentials,
  });
}
