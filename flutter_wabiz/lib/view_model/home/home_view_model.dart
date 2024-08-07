import 'package:flutter_wadiz_riverpod/model/home/home_model.dart';
import 'package:flutter_wadiz_riverpod/repository/home/home_repository.dart';
import 'package:flutter_wadiz_riverpod/shared/model/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';
part 'home_view_model.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({@Default([]) List<HomeItemModel> projects}) = _HomeState;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  HomeRepository? homeRepository;

  @override
  HomeState? build() {
    homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  update(List<HomeItemModel> projects) {
    state = state?.copyWith(
      projects: [...projects],
    );
  }

  Future<HomeModel?> fetchHomeData() async {
    final result = await homeRepository?.getHomeProjects();
    update(result?.projects ?? []);
    return result;
  }
}

@riverpod
Future<HomeModel> fetchHomeProject(FetchHomeProjectRef ref) async {
  try {
    final result =
        await ref.watch(homeViewModelProvider.notifier).fetchHomeData();
    return result ?? const HomeModel();
  } catch (e) {
    return const HomeModel();
  }
}

@riverpod
Future<List<ProjectCategory>> fetchHomeCategories(
    FetchHomeCategoriesRef ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  List<ProjectCategory> categories = [
    const ProjectCategory(
      id: 1,
      iconPath: "assets/icons/categories/1.png",
      title: "펀딩+",
    ),
    const ProjectCategory(
      id: 2,
      iconPath: "assets/icons/categories/2.png",
      title: "오픈예정",
    ),
    const ProjectCategory(
      id: 6,
      iconPath: "assets/icons/categories/6.png",
      title: "펀딩체험단",
    ),
    const ProjectCategory(
      id: 3,
      iconPath: "assets/icons/categories/3.png",
      title: "스토어",
    ),
    const ProjectCategory(
      id: 7,
      iconPath: "assets/icons/categories/7.png",
      title: "뷰티워크",
    ),
    const ProjectCategory(
      id: 4,
      iconPath: "assets/icons/categories/4.png",
      title: "예약구매",
    ),
    const ProjectCategory(
      id: 8,
      iconPath: "assets/icons/categories/8.png",
      title: "새학기 출발",
    ),
    const ProjectCategory(
      id: 5,
      iconPath: "assets/icons/categories/5.png",
      title: "혜택",
    ),
    const ProjectCategory(
      id: 9,
      iconPath: "assets/icons/categories/9.png",
      title: "오픈예정",
    ),
  ];
  return categories;
}
