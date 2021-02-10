class Utils {
  static const String EMAIL_REGEXP =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

  static String getErrorText(String errorText) {
    switch (errorText) {
      case 'invalid_credentials':
        return 'Невірний логін або пароль.';
      case 'could_not_create_token':
        return 'Виникла помилка під час логіну.\nЗ\'вяжіться з підтримкою.';
      case 'user_is_banned':
        return 'Ваш акаунт заблокований.\nЗ\'вяжіться з підтримкою.';
      case 'user_inactive':
        return 'Ваш акаунт не активний.\nЗ\'вяжіться з підтримкою.';
      case 'total_field_is_required':
        return 'Кількість обов\'язкове поле';
      case 'total_is_not_enough':
        return 'Недостатній баланс.';
      default:
        return 'Виникла помилка. Повторіть будь ласка.';
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
