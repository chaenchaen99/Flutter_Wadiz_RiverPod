import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wadiz_riverpod/model/category/category_model.dart';
import 'package:flutter_wadiz_riverpod/repository/category/category_repository.dart';
import 'package:flutter_wadiz_riverpod/shared/model/project_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_view_model.g.dart';
part 'category_view_model.freezed.dart';

enum EnumCategoryProjectType {
  recommend("추천순"),
  lowFunded("낮은 펀딩금액순"),
  highFunded("높은 펀딩금액순");

  final String value;

  const EnumCategoryProjectType(this.value);
}

@freezed
class CategoryScreenState with _$CategoryScreenState {
  factory CategoryScreenState({
    ProjectType? selectedType,
    @Default(EnumCategoryProjectType.recommend)
    EnumCategoryProjectType? projectFilter,
    @Default([]) List<CategoryItemModel> projects,
    @Default(AsyncValue.loading())
    AsyncValue<List<CategoryItemModel>> projectState,
  }) = _CategoryScreenState;
}

@riverpod
class CategoryViewModel extends _$CategoryViewModel {
  @override
  CategoryScreenState build() {
    return CategoryScreenState(
      selectedType: const ProjectType(id: 0, type: "전체"),
      projectFilter: EnumCategoryProjectType.recommend,
      projects: [],
    );
  }

  updateType(ProjectType type) {
    state = state.copyWith(
      selectedType: type,
      projectFilter: EnumCategoryProjectType.recommend,
    );
  }

  fetchProjects(String categoryId) async {
    state = state.copyWith(projectState: const AsyncValue.loading());

    String typeId = "${state.selectedType?.id}";
    if (state.selectedType?.id == 0) {
      if (state.selectedType?.type == "전체") {
        typeId = "all";
      } else {
        typeId = "best";
      }
    }

    final AsyncValue<List<CategoryItemModel>> newState =
        await AsyncValue.guard(() async {
      final response = await ref
          .watch(categoryRepositoryProvider)
          .getCategoryProjects(categoryId, typeId);
      return response.projects;
    });

    state = state.copyWith(
      projectState: newState,
      projects: newState.value ?? [],
    );
  }

  updateProjectFilter(EnumCategoryProjectType filter) {
    state = state.copyWith(
        projectState: const AsyncValue.loading(), projectFilter: filter);

    final projects = [...state.projects];

    if (filter == EnumCategoryProjectType.lowFunded) {
      projects.sort((a, b) {
        if ((a.totalFunded ?? 0) > (b.totalFunded ?? 0)) {
          return 1;
        } else {
          return -1;
        }
      });
    } else if (filter == EnumCategoryProjectType.highFunded) {
      projects.sort((a, b) {
        if ((a.totalFunded ?? 0) > (b.totalFunded ?? 0)) {
          return -1;
        } else {
          return 1;
        }
      });
    }

    state = state.copyWith(
      projectState: AsyncValue.data(projects),
      projectFilter: filter,
    );
  }
}

@riverpod
Future<List<ProjectType>> fetchTypeTabs(FetchTypeTabsRef ret) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    const ProjectType(
      id: 0,
      type: "전체",
      imagePath: "assets/icons/type/all.svg",
    ),
    const ProjectType(
      id: 0,
      type: "BEST 펀딩",
      imagePath: "assets/icons/type/best.svg",
    ),
    const ProjectType(
      id: 1,
      type: "테크가전",
      imagePath: "assets/icons/type/1.svg",
    ),
    const ProjectType(
      id: 2,
      type: "패션",
      imagePath: "assets/icons/type/2.svg",
    ),
    const ProjectType(
      id: 3,
      type: "뷰티",
      imagePath: "assets/icons/type/3.svg",
    ),
    const ProjectType(
      id: 4,
      type: "홈리빙",
      imagePath: "assets/icons/type/4.svg",
    ),
    const ProjectType(
      id: 5,
      type: "스포츠아웃도어",
      imagePath: "assets/icons/type/5.svg",
    ),
    const ProjectType(
      id: 6,
      type: "푸드",
      imagePath: "assets/icons/type/6.svg",
    ),
    const ProjectType(
      id: 7,
      type: "도서전자책",
      imagePath: "assets/icons/type/7.svg",
    ),
    const ProjectType(
      id: 8,
      type: "클래스",
      imagePath: "assets/icons/type/8.svg",
    ),
  ];
}

@riverpod
Future<CategoryModel> fetchCategoryProjects(
  FetchCategoryProjectsRef ref,
  String categoryId,
) async {
  final response = await ref
      .watch(categoryRepositoryProvider)
      .getProjectsByCategoryId(categoryId);
  return response;
}

@riverpod
Future<CategoryModel> fetchCategoryProjectsByType(
  FetchCategoryProjectsByTypeRef ref,
  String categoryId,
) async {
  final vm = ref.watch(categoryViewModelProvider);
  String typeId = "${vm.selectedType?.id}";
  if (vm.selectedType?.id == 0) {
    if (vm.selectedType?.type == "전체") {
      typeId = "all";
    } else {
      typeId = "best";
    }
  }
  final response = await ref
      .watch(categoryRepositoryProvider)
      .getCategoryProjects(categoryId, typeId);

  return response;
}
