class TourismPlace {
  final String name;
  final String location;
  final String description;
  final String openDays;
  final String openTime;
  final int ticketPrice;
  final String image;
  final String createdAt;
  final String updatedAt;
  final List<String> urlImages;

  TourismPlace({
    required this.name,
    required this.location,
    required this.description,
    required this.openDays,
    required this.openTime,
    required this.ticketPrice,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.urlImages,
  });

  factory TourismPlace.fromJson(Map<String, dynamic> json) {
    List<dynamic> imagesJson = json['tourism_place_images'] ?? [];
    List<String> images =
        imagesJson.map((image) => image['image_url'].toString()).toList();

    return TourismPlace(
      name: json['name'],
      location: json['location'],
      description: json['description'],
      openDays: json['open_days'],
      openTime: json['open_time'],
      ticketPrice: json['ticket_price'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      urlImages: images,
    );
  }
}
