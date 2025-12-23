enum DrinkListSort {
  descending,
  ascending;

  String get displayName {
    return switch (this) {
      DrinkListSort.descending => 'Newest first',
      DrinkListSort.ascending => 'Oldest first',
    };
  }

  String get description {
    return switch (this) {
      DrinkListSort.descending =>
        'Most recent drinks and sessions appear at the top',
      DrinkListSort.ascending => 'Oldest drinks and sessions appear at the top',
    };
  }
}
