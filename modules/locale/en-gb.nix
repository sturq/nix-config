{ ... }: {
  # en_GB so Qt6 renders 24h clock + day-first dates (LC_TIME alone
  # isn't enough — Qt reads LANG for QLocale).
  i18n.defaultLocale = "en_GB.UTF-8";
}
