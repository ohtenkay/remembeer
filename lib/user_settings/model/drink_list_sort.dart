enum DrinkListSort {
  descending,
  ascending;

  String get displayName {
    return switch (this) {
      DrinkListSort.descending => 'Newest first',
      DrinkListSort.ascending => 'Oldest first',
    };
  }
}
