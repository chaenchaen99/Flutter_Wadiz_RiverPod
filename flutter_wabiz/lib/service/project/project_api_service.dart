import 'package:flutter/foundation.dart';
import 'package:flutter_wadiz_riverpod/service/project/project_api.dart';
import 'package:flutter_wadiz_riverpod/shared/network_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_api_service.g.dart';

@riverpod
ProjectApiClient projectApiService(ProjectApiServiceRef ref) {
  final dio = ref.watch(dioProvider);
  var localhost = "localhost";
  if (defaultTargetPlatform == TargetPlatform.android) {
    localhost = "10.0.2.2";
  }
  return ProjectApiClient(dio, baseUrl: "http://$localhost:3000/api/v1");
}
