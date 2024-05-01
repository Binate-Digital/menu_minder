class SinglePlaceDetail {
  // List<Null>? htmlAttributions;
  Result? result;
  String? status;

  SinglePlaceDetail({this.result, this.status});

  SinglePlaceDetail.fromJson(Map<String, dynamic> json) {
    // if (json['html_attributions'] != null) {
    //   htmlAttributions = <Null>[];
    //   json['html_attributions'].forEach((v) {
    //     htmlAttributions!.add(new Null.fromJson(v));
    //   });
    // }
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if (htmlAttributions != null) {
    //   data['html_attributions'] =
    //       htmlAttributions!.map((v) => v.toJson()).toList();
    // }
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Result {
  List<AddressComponents>? addressComponents;
  String? adrAddress;
  String? businessStatus;
  CurrentOpeningHours? currentOpeningHours;
  bool? delivery;
  bool? dineIn;
  EditorialSummary? editorialSummary;
  String? formattedAddress;
  String? formattedPhoneNumber;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? internationalPhoneNumber;
  String? name;
  CurrentOpeningHours? openingHours;
  List<Photos>? photos;
  String? placeId;
  PlusCode? plusCode;
  int? priceLevel;
  double? rating;
  String? reference;
  bool? reservable;
  List<Reviews>? reviews;
  bool? servesBeer;
  bool? servesBreakfast;
  bool? servesBrunch;
  bool? servesDinner;
  bool? servesLunch;
  bool? servesVegetarianFood;
  bool? servesWine;
  bool? takeout;
  List<String>? types;
  String? url;
  int? userRatingsTotal;
  int? utcOffset;
  String? vicinity;
  String? website;
  bool? wheelchairAccessibleEntrance;

  Result(
      {this.addressComponents,
      this.adrAddress,
      this.businessStatus,
      this.currentOpeningHours,
      this.delivery,
      this.dineIn,
      this.editorialSummary,
      this.formattedAddress,
      this.formattedPhoneNumber,
      this.geometry,
      this.icon,
      this.iconBackgroundColor,
      this.iconMaskBaseUri,
      this.internationalPhoneNumber,
      this.name,
      this.openingHours,
      this.photos,
      this.placeId,
      this.plusCode,
      this.priceLevel,
      this.rating,
      this.reference,
      this.reservable,
      this.reviews,
      this.servesBeer,
      this.servesBreakfast,
      this.servesBrunch,
      this.servesDinner,
      this.servesLunch,
      this.servesVegetarianFood,
      this.servesWine,
      this.takeout,
      this.types,
      this.url,
      this.userRatingsTotal,
      this.utcOffset,
      this.vicinity,
      this.website,
      this.wheelchairAccessibleEntrance});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponents>[];
      json['address_components'].forEach((v) {
        addressComponents!.add(AddressComponents.fromJson(v));
      });
    }
    adrAddress = json['adr_address'];
    businessStatus = json['business_status'];
    currentOpeningHours = json['current_opening_hours'] != null
        ? CurrentOpeningHours.fromJson(json['current_opening_hours'])
        : null;
    delivery = json['delivery'];
    dineIn = json['dine_in'];
    editorialSummary = json['editorial_summary'] != null
        ? EditorialSummary.fromJson(json['editorial_summary'])
        : null;
    formattedAddress = json['formatted_address'];
    formattedPhoneNumber = json['formatted_phone_number'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    internationalPhoneNumber = json['international_phone_number'];
    name = json['name'];
    openingHours = json['opening_hours'] != null
        ? CurrentOpeningHours.fromJson(json['opening_hours'])
        : null;
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    priceLevel = json['price_level'];
    rating = json['rating'] != null
        ? double.parse(json['rating'].toString())
        : rating;
    reference = json['reference'];
    reservable = json['reservable'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    servesBeer = json['serves_beer'];
    servesBreakfast = json['serves_breakfast'];
    servesBrunch = json['serves_brunch'];
    servesDinner = json['serves_dinner'];
    servesLunch = json['serves_lunch'];
    servesVegetarianFood = json['serves_vegetarian_food'];
    servesWine = json['serves_wine'];
    takeout = json['takeout'];
    types = json['types'].cast<String>();
    url = json['url'];
    userRatingsTotal = json['user_ratings_total'];
    utcOffset = json['utc_offset'];
    vicinity = json['vicinity'];
    website = json['website'];
    wheelchairAccessibleEntrance = json['wheelchair_accessible_entrance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addressComponents != null) {
      data['address_components'] =
          addressComponents!.map((v) => v.toJson()).toList();
    }
    data['adr_address'] = adrAddress;
    data['business_status'] = businessStatus;
    if (currentOpeningHours != null) {
      data['current_opening_hours'] = currentOpeningHours!.toJson();
    }
    data['delivery'] = delivery;
    data['dine_in'] = dineIn;
    if (editorialSummary != null) {
      data['editorial_summary'] = editorialSummary!.toJson();
    }
    data['formatted_address'] = formattedAddress;
    data['formatted_phone_number'] = formattedPhoneNumber;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['icon'] = icon;
    data['icon_background_color'] = iconBackgroundColor;
    data['icon_mask_base_uri'] = iconMaskBaseUri;
    data['international_phone_number'] = internationalPhoneNumber;
    data['name'] = name;
    if (openingHours != null) {
      data['opening_hours'] = openingHours!.toJson();
    }
    if (photos != null) {
      data['photos'] = photos!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    if (plusCode != null) {
      data['plus_code'] = plusCode!.toJson();
    }
    data['price_level'] = priceLevel;
    data['rating'] = rating;
    data['reference'] = reference;
    data['reservable'] = reservable;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['serves_beer'] = servesBeer;
    data['serves_breakfast'] = servesBreakfast;
    data['serves_brunch'] = servesBrunch;
    data['serves_dinner'] = servesDinner;
    data['serves_lunch'] = servesLunch;
    data['serves_vegetarian_food'] = servesVegetarianFood;
    data['serves_wine'] = servesWine;
    data['takeout'] = takeout;
    data['types'] = types;
    data['url'] = url;
    data['user_ratings_total'] = userRatingsTotal;
    data['utc_offset'] = utcOffset;
    data['vicinity'] = vicinity;
    data['website'] = website;
    data['wheelchair_accessible_entrance'] = wheelchairAccessibleEntrance;
    return data;
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long_name'] = longName;
    data['short_name'] = shortName;
    data['types'] = types;
    return data;
  }
}

class CurrentOpeningHours {
  bool? openNow;
  List<Periods>? periods;
  List<String>? weekdayText;

  CurrentOpeningHours({this.openNow, this.periods, this.weekdayText});

  CurrentOpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
    if (json['periods'] != null) {
      periods = <Periods>[];
      json['periods'].forEach((v) {
        periods!.add(Periods.fromJson(v));
      });
    }
    weekdayText = json['weekday_text'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_now'] = openNow;
    if (periods != null) {
      data['periods'] = periods!.map((v) => v.toJson()).toList();
    }
    data['weekday_text'] = weekdayText;
    return data;
  }
}

class Periods {
  Close? close;
  Close? open;

  Periods({this.close, this.open});

  Periods.fromJson(Map<String, dynamic> json) {
    close = json['close'] != null ? Close.fromJson(json['close']) : null;
    open = json['open'] != null ? Close.fromJson(json['open']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (close != null) {
      data['close'] = close!.toJson();
    }
    if (open != null) {
      data['open'] = open!.toJson();
    }
    return data;
  }
}

class Close {
  String? date;
  int? day;
  String? time;

  Close({this.date, this.day, this.time});

  Close.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day'] = day;
    data['time'] = time;
    return data;
  }
}

class EditorialSummary {
  String? language;
  String? overview;

  EditorialSummary({this.language, this.overview});

  EditorialSummary.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    overview = json['overview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    data['overview'] = overview;
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (viewport != null) {
      data['viewport'] = viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast =
        json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
    southwest =
        json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (northeast != null) {
      data['northeast'] = northeast!.toJson();
    }
    if (southwest != null) {
      data['southwest'] = southwest!.toJson();
    }
    return data;
  }
}

// class Close {
//   int? day;
//   String? time;

//   Close({this.day, this.time});

//   Close.fromJson(Map<String, dynamic> json) {
//     day = json['day'];
//     time = json['time'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['day'] = day;
//     data['time'] = time;
//     return data;
//   }
// }

class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['html_attributions'] = htmlAttributions;
    data['photo_reference'] = photoReference;
    data['width'] = width;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['compound_code'] = compoundCode;
    data['global_code'] = globalCode;
    return data;
  }
}

class Reviews {
  String? authorName;
  String? authorUrl;
  String? language;
  String? originalLanguage;
  String? profilePhotoUrl;
  double? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;
  bool? translated;

  Reviews(
      {this.authorName,
      this.authorUrl,
      this.language,
      this.originalLanguage,
      this.profilePhotoUrl,
      this.rating,
      this.relativeTimeDescription,
      this.text,
      this.time,
      this.translated});

  Reviews.fromJson(Map<String, dynamic> json) {
    authorName = json['author_name'];
    authorUrl = json['author_url'];
    language = json['language'];
    originalLanguage = json['original_language'];
    profilePhotoUrl = json['profile_photo_url'];
    rating =
        json['rating'] != null ? double.parse(json['rating'].toString()) : null;
    relativeTimeDescription = json['relative_time_description'];
    text = json['text'];
    time = json['time'];
    translated = json['translated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author_name'] = authorName;
    data['author_url'] = authorUrl;
    data['language'] = language;
    data['original_language'] = originalLanguage;
    data['profile_photo_url'] = profilePhotoUrl;
    data['rating'] = rating;
    data['relative_time_description'] = relativeTimeDescription;
    data['text'] = text;
    data['time'] = time;
    data['translated'] = translated;
    return data;
  }
}
