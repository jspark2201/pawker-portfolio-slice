import 'package:pawker/domain/entities/faq/faq.dart';

abstract class FaqRepository {
  Future<List<Faq>> getFaqs();
}
