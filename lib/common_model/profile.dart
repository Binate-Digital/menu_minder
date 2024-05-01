class Profile {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? location;
  String? bio;
  String? image;
  String? code;

  Profile(
      {this.name,
      this.email,
      this.id,
      this.phone,
      this.location,
      this.bio,
      this.image,
      this.code = "+1"});
}
