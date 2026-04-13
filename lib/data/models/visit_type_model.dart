class VisitTypeQuestion {
  VisitTypeQuestion({
    required this.id,
    this.questionText,
    this.isActive,
    this.displayOrder,
  });

  factory VisitTypeQuestion.fromJson(Map<String, dynamic> json) {
    return VisitTypeQuestion(
      id: json['id'] as int? ?? 0,
      questionText: json['question_text'] as String?,
      isActive: json['is_active'] as bool?,
      displayOrder: json['display_order'] as int?,
    );
  }

  final int id;
  final String? questionText;
  final bool? isActive;
  final int? displayOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'is_active': isActive,
      'display_order': displayOrder,
    };
  }
}

class VisitTypeModel {
  VisitTypeModel({
    required this.id,
    this.organizationId,
    required this.name,
    this.description,
    this.isActive,
    this.isVisibleInSummary,
    this.displayOrder,
    this.isDefault,
    this.isDeleted,
    this.colorCode,
    this.defaultDuration,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.questions,
    this.isVisibleToUser,
  });

  factory VisitTypeModel.fromJson(Map<String, dynamic> json) {
    return VisitTypeModel(
      id: json['id'] as int? ?? 0,
      organizationId: json['organization_id'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool?,
      isVisibleInSummary: json['is_visible_in_summary'] as bool?,
      displayOrder: json['display_order'] as int?,
      isDefault: json['is_default'] as bool?,
      isDeleted: json['is_deleted'] as bool?,
      colorCode: json['color_code'] as String?,
      defaultDuration: json['default_duration'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => VisitTypeQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      isVisibleToUser: json['is_visible_to_user'] as bool?,
    );
  }

  final int id;
  final int? organizationId;
  final String name;
  final String? description;
  final bool? isActive;
  final bool? isVisibleInSummary;
  final int? displayOrder;
  final bool? isDefault;
  final bool? isDeleted;
  final String? colorCode;
  final int? defaultDuration;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final List<VisitTypeQuestion>? questions;
  final bool? isVisibleToUser;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'description': description,
      'is_active': isActive,
      'is_visible_in_summary': isVisibleInSummary,
      'display_order': displayOrder,
      'is_default': isDefault,
      'is_deleted': isDeleted,
      'color_code': colorCode,
      'default_duration': defaultDuration,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      if (questions != null) 'questions': questions!.map((e) => e.toJson()).toList(),
      'is_visible_to_user': isVisibleToUser,
    };
  }
}
