import '../database.dart';

class ApodTable extends SupabaseTable<ApodRow> {
  @override
  String get tableName => 'apod';

  @override
  ApodRow createRow(Map<String, dynamic> data) => ApodRow(data);
}

class ApodRow extends SupabaseDataRow {
  ApodRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ApodTable();

  DateTime get apodDate => getField<DateTime>('apod_date')!;
  set apodDate(DateTime value) => setField<DateTime>('apod_date', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get description => getField<String>('description')!;
  set description(String value) => setField<String>('description', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get hdImageUrl => getField<String>('hd_image_url');
  set hdImageUrl(String? value) => setField<String>('hd_image_url', value);

  String? get mediaType => getField<String>('media_type');
  set mediaType(String? value) => setField<String>('media_type', value);

  DateTime? get fetchedAt => getField<DateTime>('fetched_at');
  set fetchedAt(DateTime? value) => setField<DateTime>('fetched_at', value);

  String? get blurHash => getField<String>('blur_hash');
  set blurHash(String? value) => setField<String>('blur_hash', value);
}
