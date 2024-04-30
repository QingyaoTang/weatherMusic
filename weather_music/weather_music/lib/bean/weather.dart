class Weather {
   String ?city;
   String ?wea;
   String ?tem;
   String ?icon;


  Weather({
     this.city,
     this.wea,
     this.tem,
     this.icon
  });

  Weather.fromMap(Map map) {
    city = map["city"];
    wea = map["day"]["phrase"];
    tem = map["day"]["temperature"];
    icon = map["day"]["icon"];

  }

}