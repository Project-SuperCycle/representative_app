import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:supercycle/core/errors/failures.dart';

abstract class SalesProcessRepo {
  Future<Either<Failure, String>> createShipment({required FormData shipment});
}
