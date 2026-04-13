class OrganizationModel {
  final int? id;
  final String? organizationId;
  final String? name;
  final bool? isEmaIntegration;
  final bool? autoSendToEma;
  final bool? hasEPrescription;
  final bool? hasLabOrder;
  final bool? isInternal;
  final String? profileImage;
  final String? uploadedAt;
  final String? email;
  final String? contactNo;
  final String? country;
  final String? state;
  final String? stateCode;
  final String? city;
  final String? streetName;
  final String? address1;
  final String? address2;
  final String? postalCode;
  final int? providersCount;
  final String? appointmentType;
  final String? preference;
  final String? noteApplicationScope;
  final String? defaultCustomInstructions;
  final String? defaultFormat;
  final String? defaultTone;
  final String? invoiceEmail;
  final String? stripeCustomerId;
  final bool? hasOptumIntegration;
  final String? stediProviderId;
  final String? npi;
  final String? taxId;
  final String? taxIdType;
  final String? taxonomyCode;
  final bool? transcriptRetentionEnabled;
  final int? transcriptRetentionDays;
  final String? lastAutoDeletionRun;
  final bool? allowNoteAndTranscriptDeletion;
  final List<String>? emaCompositionSections;
  final bool? isEmaLiteEnabled;
  final String? outstandingBalance;
  final List<dynamic>? contacts;
  final String? twilioNumber;
  final bool? hasEmrSubscription;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final bool? hasEmaConfigs;
  final bool? hasSubscription;
  final List<dynamic>? emaConfigs;
  final int? employeesCount;
  final String? efaxEmail;
  final String? cloudFaxNumber;

  OrganizationModel({
    this.id,
    this.organizationId,
    this.name,
    this.isEmaIntegration,
    this.autoSendToEma,
    this.hasEPrescription,
    this.hasLabOrder,
    this.isInternal,
    this.profileImage,
    this.uploadedAt,
    this.email,
    this.contactNo,
    this.country,
    this.state,
    this.stateCode,
    this.city,
    this.streetName,
    this.address1,
    this.address2,
    this.postalCode,
    this.providersCount,
    this.appointmentType,
    this.preference,
    this.noteApplicationScope,
    this.defaultCustomInstructions,
    this.defaultFormat,
    this.defaultTone,
    this.invoiceEmail,
    this.stripeCustomerId,
    this.hasOptumIntegration,
    this.stediProviderId,
    this.npi,
    this.taxId,
    this.taxIdType,
    this.taxonomyCode,
    this.transcriptRetentionEnabled,
    this.transcriptRetentionDays,
    this.lastAutoDeletionRun,
    this.allowNoteAndTranscriptDeletion,
    this.emaCompositionSections,
    this.isEmaLiteEnabled,
    this.outstandingBalance,
    this.contacts,
    this.twilioNumber,
    this.hasEmrSubscription,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.hasEmaConfigs,
    this.hasSubscription,
    this.emaConfigs,
    this.employeesCount,
    this.efaxEmail,
    this.cloudFaxNumber,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] as int?,
      organizationId: json['organization_id'] as String?,
      name: json['name'] as String?,
      isEmaIntegration: json['is_ema_integration'] as bool?,
      autoSendToEma: json['auto_send_to_ema'] as bool?,
      hasEPrescription: json['has_ePrescription'] as bool?,
      hasLabOrder: json['has_lab_order'] as bool?,
      isInternal: json['is_internal'] as bool?,
      profileImage: json['profile_image'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
      email: json['email'] as String?,
      contactNo: json['contact_no'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      stateCode: json['state_code'] as String?,
      city: json['city'] as String?,
      streetName: json['street_name'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      postalCode: json['postal_code'] as String?,
      providersCount: json['providers_count'] as int?,
      appointmentType: json['appointment_type'] as String?,
      preference: json['preference'] as String?,
      noteApplicationScope: json['note_application_scope'] as String?,
      defaultCustomInstructions: json['default_custom_instructions'] as String?,
      defaultFormat: json['default_format'] as String?,
      defaultTone: json['default_tone'] as String?,
      invoiceEmail: json['invoice_email'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      hasOptumIntegration: json['has_optum_integration'] as bool?,
      stediProviderId: json['stedi_provider_id'] as String?,
      npi: json['npi'] as String?,
      taxId: json['tax_id'] as String?,
      taxIdType: json['tax_id_type'] as String?,
      taxonomyCode: json['taxonomy_code'] as String?,
      transcriptRetentionEnabled: json['transcript_retention_enabled'] as bool?,
      transcriptRetentionDays: json['transcript_retention_days'] as int?,
      lastAutoDeletionRun: json['last_auto_deletion_run'] as String?,
      allowNoteAndTranscriptDeletion: json['allow_note_and_transcript_deletion'] as bool?,
      emaCompositionSections: (json['ema_composition_sections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isEmaLiteEnabled: json['is_ema_lite_enabled'] as bool?,
      outstandingBalance: json['outstanding_balance'] as String?,
      contacts: json['contacts'] as List<dynamic>?,
      twilioNumber: json['twilio_number'] as String?,
      hasEmrSubscription: json['has_emr_subscription'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      hasEmaConfigs: json['has_ema_configs'] as bool?,
      hasSubscription: json['has_subscription'] as bool?,
      emaConfigs: json['ema_configs'] as List<dynamic>?,
      employeesCount: json['employeesCount'] as int?,
      efaxEmail: json['efaxEmail'] as String?,
      cloudFaxNumber: json['cloudFaxNumber'] as String?,
    );
  }
}
