/// Public sample credentials for this offline demo; never use real passwords.
class MockUserAccount {
  const MockUserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarEmoji,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String avatarEmoji;
}

abstract final class MockUsers {
  static const List<MockUserAccount> accounts = [
    MockUserAccount(
      id: 'OWL-1001',
      name: 'Muhammad Abbas',
      email: 'abbas@example.com',
      password: 'Owlance@123',
      avatarEmoji: '🦉',
    ),
    MockUserAccount(
      id: 'OWL-1002',
      name: 'Danish',
      email: 'danish@example.com',
      password: 'Danish@123',
      avatarEmoji: '🐵',
    ),
    MockUserAccount(
      id: 'OWL-1003',
      name: 'Syed Hassan Shah',
      email: 'hassan@example.com',
      password: 'Hassan@123',
      avatarEmoji: '🦁',
    ),
  ];

  static const String demoUserId = 'OWL-1001';
  static const String demoName = 'Muhammad Abbas';
  static const String demoEmail = 'abbas@example.com';
  static const String demoPassword = 'Owlance@123';
  static const String demoAvatar = '🦉';
  static const String disclosure =
      'Offline demo accounts · change names, IDs, emails, passwords, and avatars in lib/mock/mock_users.dart';
}
