import 'dart:convert' as convert;

String getImage(String imgJson) {
  try {
    Map<String,dynamic> json = convert.jsonDecode(imgJson);
    if(json.containsKey('full')){
      print('parsedJson ' + json['full']);
      return json['full'];
    }
    print('not parsedJson ' + imgJson);
    return imgJson;
  } catch(e){
    if(imgJson.startsWith('"\\"'))
      imgJson = imgJson.substring(3,imgJson.length-3);
    print('exception ' + imgJson);
    return imgJson;
  }
}