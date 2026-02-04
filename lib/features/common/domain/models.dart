class Internship {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final String? requirements;
  final String? duration;
  final String? location;
  final DateTime? deadline;
  final bool isActive;
  final DateTime createdAt;
  // Optional relation
  final CompanyProfile? company;

  Internship({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    this.requirements,
    this.duration,
    this.location,
    this.deadline,
    this.isActive = true,
    required this.createdAt,
    this.company,
  });

  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      id: map['id'] ?? '',
      companyId: map['company_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      requirements: map['requirements'],
      duration: map['duration'],
      location: map['location'],
      deadline:
          map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at']),
      company: map['companies'] != null
          ? CompanyProfile.fromMap(map['companies'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company_id': companyId,
      'title': title,
      'description': description,
      'requirements': requirements,
      'duration': duration,
      'location': location,
      'deadline': deadline?.toIso8601String(),
      'is_active': isActive,
    };
  }

  // CopyWith for editing/updates
  Internship copyWith({
    String? id,
    String? companyId,
    String? title,
    String? description,
    String? requirements,
    String? duration,
    String? location,
    DateTime? deadline,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Internship(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      deadline: deadline ?? this.deadline,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Application {
  final String id;
  final String internshipId;
  final String studentName;
  final String email;
  final String? phone;
  final String? userAuthId; // Link to auth user if exists
  final String university;
  final String course;
  final String? motivation;
  final String registrationNumber; // Academic registration number for tracking
  final String status; // under_review, accepted, rejected
  final DateTime createdAt;

  // Optional relations
  final Internship? internship;

  Application({
    required this.id,
    required this.internshipId,
    required this.studentName,
    required this.email,
    this.phone,
    this.userAuthId,
    required this.university,
    required this.course,
    this.motivation,
    required this.registrationNumber,
    required this.status,
    required this.createdAt,
    this.internship,
  });

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'] ?? '',
      internshipId: map['internship_id'] ?? '',
      studentName: map['student_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      userAuthId: map['student_id'],
      university: map['university'] ?? '',
      course: map['course'] ?? '',
      motivation: map['motivation'],
      registrationNumber: map['registration_number'] ?? '',
      status: map['status'] ?? 'under_review',
      createdAt: DateTime.parse(map['created_at']),
      internship: map['internships'] != null
          ? Internship.fromMap(map['internships'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // don't send ID on creation
      'internship_id': internshipId,
      'student_name': studentName,
      'email': email,
      'phone': phone,
      'student_id': userAuthId,
      'university': university,
      'course': course,
      'motivation': motivation,
      'registration_number': registrationNumber,
      'status': status,
    };
  }
}

class CompanyProfile {
  final String id;
  final String name;
  final String? logoUrl;
  final String? description;
  final String? industry;
  final String? contactInfo;

  CompanyProfile({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.industry,
    this.contactInfo,
  });

  factory CompanyProfile.fromMap(Map<String, dynamic> map) {
    return CompanyProfile(
      id: map['id'],
      name: map['name'] ?? '',
      logoUrl: map['logo_url'],
      description: map['description'],
      industry: map['industry'],
      contactInfo: map['contact_info'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logo_url': logoUrl,
      'description': description,
      'industry': industry,
      'contact_info': contactInfo,
    };
  }
}
