/// 반려동물 자격증 도메인 모델
class PetCertification {
  final String id;
  final String name;
  final String? description;
  final String linkUrl;
  final bool isOfficial;
  final int sortOrder;

  const PetCertification({
    required this.id,
    required this.name,
    this.description,
    required this.linkUrl,
    required this.isOfficial,
    required this.sortOrder,
  });
}
