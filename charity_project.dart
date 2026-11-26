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

  factory CharityProject.fromCloud(Map<String, dynamic> row, {int raised = 0}) => CharityProject(
    id: row['id'].toString(),
    titleUz: row['title_uz'] as String? ?? '',
    titleRu: row['title_ru'] as String? ?? '',
    titleEn: row['title_en'] as String? ?? '',
    descriptionUz: row['description_uz'] as String? ?? '',
    descriptionRu: row['description_ru'] as String? ?? '',
    descriptionEn: row['description_en'] as String? ?? '',
    goal: (row['target_amount'] as num?)?.toInt() ?? 1,
    raised: raised,
    category: row['category'] as String? ?? 'social',
  );

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
