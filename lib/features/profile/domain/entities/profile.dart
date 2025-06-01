import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String imageUrl;

  const Profile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.imageUrl,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, fullName, imageUrl];
}
