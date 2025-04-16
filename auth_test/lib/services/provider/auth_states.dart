class AuthStates {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userType;

  const AuthStates({
    required this.isLoading,
    required this.isAuthenticated,
    this.userType,
  });

  factory AuthStates.loading() =>
      AuthStates(isLoading: true, isAuthenticated: false);
  factory AuthStates.loggedOut() =>
      AuthStates(isLoading: false, isAuthenticated: false);
  factory AuthStates.loggedIn(String userType) =>
      AuthStates(isLoading: false, isAuthenticated: true, userType: userType);
}
