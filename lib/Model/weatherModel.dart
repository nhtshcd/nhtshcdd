class WeatherModel {
  City? city;
  var cnt;
  var cod;
  List<X>? list;
  var message;

  WeatherModel({this.city, this.cnt, this.cod, this.list, this.message});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'] != null ? City.fromJson(json['city']) : null,
      cnt: json['cnt'],
      cod: json['cod'],
      list: json['list'] != null ? (json['list'] as List).map((i) => X.fromJson(i)).toList() : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnt'] = this.cnt;
    data['cod'] = this.cod;
    data['message'] = this.message;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  Coord? coord;
  String? country;
  var id;
  var name;
  var population;
  var timezone;

  City({this.coord, this.country, this.id, this.name, this.population, this.timezone});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
      country: json['country'],
      id: json['id'],
      name: json['name'],
      population: json['population'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['id'] = this.id;
    data['name'] = this.name;
    data['population'] = this.population;
    data['timezone'] = this.timezone;
    if (this.coord != null) {
      data['coord'] = this.coord!.toJson();
    }
    return data;
  }
}

class Coord {
  var lat;
  var lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class X {
  var clouds;
  var deg;
  var dt;
  var gust;
  var humidity;
  var pop;
  var pressure;
  var rain;
  var speed;
  var sunrise;
  var sunset;
  Temp? temp;
  List<Weather>? weather;

  X({this.clouds, this.deg, this.dt, this.gust, this.humidity, this.pop, this.pressure, this.rain, this.speed, this.sunrise, this.sunset, this.temp, this.weather});

  factory X.fromJson(Map<String, dynamic> json) {
    return X(
      clouds: json['clouds'],
      deg: json['deg'],
      dt: json['dt'],
      gust: json['gust'],
      humidity: json['humidity'],
      pop: json['pop'],
      pressure: json['pressure'],
      rain: json['rain'],
      speed: json['speed'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      temp: json['temp'] != null ? Temp.fromJson(json['temp']) : null,
      weather: json['weather'] != null ? (json['weather'] as List).map((i) => Weather.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clouds'] = this.clouds;
    data['deg'] = this.deg;
    data['dt'] = this.dt;
    data['gust'] = this.gust;
    data['humidity'] = this.humidity;
    data['pop'] = this.pop;
    data['pressure'] = this.pressure;
    data['rain'] = this.rain;
    data['speed'] = this.speed;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    if (this.temp != null) {
      data['temp'] = this.temp!.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  var description;
  var icon;
  var id;
  var main;

  Weather({this.description, this.icon, this.id, this.main});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['description'],
      icon: json['icon'],
      id: json['id'],
      main: json['main'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['main'] = this.main;
    return data;
  }
}

class Temp {

  var day;
  var eve;
  var max;
  var min;
  var morn;
  var night;

  Temp({this.day, this.eve, this.max, this.min, this.morn, this.night});

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      day: double.parse(json['day'].toString()),
      eve: json['eve'],
      max: json['max'],
      min: json['min'],
      morn: json['morn'],
      night: json['night'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['eve'] = this.eve;
    data['max'] = this.max;
    data['min'] = this.min;
    data['morn'] = this.morn;
    data['night'] = this.night;
    return data;
  }
}

