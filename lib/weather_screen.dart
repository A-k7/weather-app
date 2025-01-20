import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async {
    try{
      String cityname ='chandigarh';
    final res = await http.get(
      Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openApiKey')
    );

    final data = jsonDecode(res.body);
    if(data['cod']!='200'){
      throw 'error occur';
    }
    return data;

    }catch(e){
      throw e.toString();
    } 
  } 
  @override
  void initState() {
    super.initState();
    weather=getCurrentWeather();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              weather=getCurrentWeather();
            });
          },
           icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currenttemp = data['list'][0]['main']['temp'];
          final currentsky = data['list'][0]['weather'][0]['main'];
          final currenthumidity =data['list'][0]['main']['humidity'];
          final currentwindspeed=data['list'][0]['wind']['speed'];
          final currentpressure=data['list'][0]['main']['pressure'];

          return Padding(
          padding: const  EdgeInsets.all(16.0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextField(decoration: InputDecoration(hintText: "Enter the city name", ),),
                const SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child:  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text("$currenttemp K",style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              const SizedBox(height: 10,),
                              Icon(currentsky=='Clouds' ? Icons.cloud : (currentsky=='Rain'? Icons.cloudy_snowing:Icons.sunny),
                                size: 70,),
                              const SizedBox(height: 10,),
                              Text(currentsky,style: const TextStyle(fontSize:20 ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const Text("Weather Forecast",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 6,),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for(int i=0;i<6;i++)
                //       Hourlyforecastitem(time: data['list'][i]['dt'].toString(),
                //       icon: data['list'][i]['weather'][0]['main']=='Clouds' ? Icons.cloud : (data['list'][i]['weather'][0]['main']=='Rain'? Icons.cloudy_snowing:Icons.sunny),
                //       temperature: data['list'][i]['main']['temp'].toString()),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final time = DateTime.parse(data['list'][index+1]['dt_txt']);
                      return Hourlyforecastitem(
                        time: DateFormat.Hm().format(time),
                        icon: data['list'][index+1]['weather'][0]['main']=='Clouds' ? Icons.cloud : (data['list'][index+1]['weather'][0]['main']=='Rain'? Icons.cloudy_snowing:Icons.sunny),
                        temperature: data['list'][index+1]['main']['temp'].toString());
                    },),
                ),
                const SizedBox(height: 20,),
                const Text("Additional Information",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 12,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Additionalinfoitem(icon: Icons.water_drop_outlined,label: 'Humidity',value: '$currenthumidity',),
                    Additionalinfoitem(icon: Icons.air_outlined,label: 'Wind Speed',value: '$currentwindspeed',),
                    Additionalinfoitem(icon: Icons.line_weight,label: 'pressure',value: '$currentpressure',),
                  ],
                ),
              ],
            ),
        );
        },
      ), 
    );
  }
}