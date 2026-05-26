enum ShelfStatus { wantToRead, reading, completed }

extension ShelfStatusX on ShelfStatus {
  String get label {
    switch (this) {
      case ShelfStatus.wantToRead:
        return 'Want to Read';
      case ShelfStatus.reading:
        return 'Reading';
      case ShelfStatus.completed:
        return 'Completed';
    }
  }

  String get storageValue {
    switch (this) {
      case ShelfStatus.wantToRead:
        return 'want_to_read';
      case ShelfStatus.reading:
        return 'reading';
      case ShelfStatus.completed:
        return 'completed';
    }
  }
}

ShelfStatus? shelfStatusFromStorage(String? value) {
  switch (value) {
    case 'want_to_read':
      return ShelfStatus.wantToRead;
    case 'reading':
      return ShelfStatus.reading;
    case 'completed':
      return ShelfStatus.completed;
    default:
      return null;
  }
}
