class CharityProject {
  final String id;
  final String titleUz, titleRu, titleEn;
  final String descriptionUz, descriptionRu, descriptionEn;
  final int goal, raised;
  final String category;

  const CharityProject({
    required this.id,
    required this.titleUz,
    required this.titleRu,
    required this.titleEn,
    required this.descriptionUz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.goal,
    required this.raised,
    required this.category,
  });

  factory CharityProject.fromCloud(
    Map<String, dynamic> row, {
    int raised = 0,
  }) {
    final title = (row['title'] ?? '').toString();
    final description = (row['description'] ?? '').toString();

    return CharityProject(
      id: row['id'].toString(),
      titleUz: (row['title_uz'] ?? title).toString(),
      titleRu: (row['title_ru'] ?? title).toString(),
      titleEn: (row['title_en'] ?? title).toString(),
      descriptionUz:
          (row['description_uz'] ?? description).toString(),
      descriptionRu:
          (row['description_ru'] ?? description).toString(),
      descriptionEn:
          (row['description_en'] ?? description).toString(),
      goal: (row['goal_amount'] as num?)?.toInt() ?? 1,
      raised: raised,
      category: (row['category'] ?? 'social').toString(),
    );
  }

  String title(String lang) => switch (lang) {
        'ru' => titleRu,
        'en' => titleEn,
        _ => titleUz,
      };

  String description(String lang) => switch (lang) {
        'ru' => descriptionRu,
        'en' => descriptionEn,
        _ => descriptionUz,
      };
}
