class Strings {
  static const Map<String, Map<String, String>> _data = {
    'uz': {
      'home': 'Bosh sahifa', 'projects': 'Loyihalar', 'history': 'Tarix', 'profile': 'Profil',
      'tagline': 'Birgalikda ezgulik sari!', 'raised': 'Jami xayriya', 'beneficiaries': 'Yordam oluvchilar',
      'active_projects': 'Faol loyihalar', 'featured': 'Xayriya loyihalari', 'see_all': 'Barchasi',
      'donate': 'Xayriya qilish', 'demo': 'DEMO REJIM', 'demo_note': 'Bu sinov rejimi. Haqiqiy pul yechilmaydi.',
      'amount': 'Xayriya summasi (so‘m)', 'continue': 'Davom etish', 'cancel': 'Bekor qilish',
      'success': 'Demo xayriya muvaffaqiyatli qayd etildi', 'history_empty': 'Hozircha xayriya tarixi yo‘q.',
      'language': 'Ilova tili', 'about': 'Jamg‘arma haqida', 'transparency': 'Shaffoflik',
      'goal': 'Maqsad', 'collected': 'Yig‘ildi', 'choose_amount': 'Summani tanlang',
    },
    'ru': {
      'home': 'Главная', 'projects': 'Проекты', 'history': 'История', 'profile': 'Профиль',
      'tagline': 'Вместе к добрым делам!', 'raised': 'Всего пожертвовано', 'beneficiaries': 'Получатели помощи',
      'active_projects': 'Активные проекты', 'featured': 'Благотворительные проекты', 'see_all': 'Все',
      'donate': 'Пожертвовать', 'demo': 'ДЕМО-РЕЖИМ', 'demo_note': 'Тестовый режим. Реальные деньги не списываются.',
      'amount': 'Сумма пожертвования (сум)', 'continue': 'Продолжить', 'cancel': 'Отмена',
      'success': 'Демо-пожертвование успешно записано', 'history_empty': 'История пожертвований пока пуста.',
      'language': 'Язык приложения', 'about': 'О фонде', 'transparency': 'Прозрачность',
      'goal': 'Цель', 'collected': 'Собрано', 'choose_amount': 'Выберите сумму',
    },
    'en': {
      'home': 'Home', 'projects': 'Projects', 'history': 'History', 'profile': 'Profile',
      'tagline': 'Together for good!', 'raised': 'Total donations', 'beneficiaries': 'People supported',
      'active_projects': 'Active projects', 'featured': 'Charity projects', 'see_all': 'See all',
      'donate': 'Donate', 'demo': 'DEMO MODE', 'demo_note': 'Test mode. No real money will be charged.',
      'amount': 'Donation amount (UZS)', 'continue': 'Continue', 'cancel': 'Cancel',
      'success': 'Demo donation recorded successfully', 'history_empty': 'No donation history yet.',
      'language': 'App language', 'about': 'About the fund', 'transparency': 'Transparency',
      'goal': 'Goal', 'collected': 'Raised', 'choose_amount': 'Choose amount',
    },
  };

  static String t(String lang, String key) => _data[lang]?[key] ?? _data['uz']![key] ?? key;
}
