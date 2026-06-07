{ pkgs, ... }: {
  # CLI essentials. Bare to claude-code only — add tools back here as
  # you discover what you actually use day-to-day.
  home.packages = with pkgs; [
    claude-code
  ];
}
