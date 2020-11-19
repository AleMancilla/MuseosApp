// ...
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

final HttpLink _httpLink = HttpLink(
    uri: 'https://museosapp.herokuapp.com/v1/graphql',
    headers: {
      "content-type":"application/json",
      "x-hasura-admin-secret":"AleAdminMuseosApp"
    },
);
final AuthLink _authLink = AuthLink(
    getToken: () async => 'Bearer AleAdminMuseosApp',
);

final Link _link = _authLink.concat(_httpLink);


final GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: _link,
    );

// ..

const String comprovanteDePago = r'''
  query pago {
    Verificacion(where: {id: {_eq: "4dee3e52-c10f-44db-8bf7-3a5b9c13367d"}}) {
      pagoCompletado
    }
  }

''';

Future<bool> comprovandoPago()async{

  // const int nRepositories = 50;

  final QueryOptions options = QueryOptions(
      documentNode: gql(comprovanteDePago),
      // variables: <String, dynamic>{
      //     'nRepositories': nRepositories,
      // },
  );
  // ...

  final QueryResult result = await _client.query(options);

  if (result.hasException) {
      print(result.exception.toString());
  }
  print(result.data);
  // return true;
  final bool repositories =
      result.data['Verificacion'][0]["pagoCompletado"];


  return repositories;
  // ...
}

/////////////////
const String inserUser = r'''
  mutation insertUser($email: String , $name: String , $pass: String , $phone: String ) {
  insert_User(objects: {email: $email, name: $name, pass: $pass, phone: $phone}) {
    returning {
      email
      idUser
      name
      pass
      phone
    }
  }
}

''';

Future<bool> insertUser({String email, String name, String pass, String phone})async{
  final MutationOptions options = MutationOptions(
    documentNode: gql(inserUser),
    variables: <String, dynamic>{
      "email": email,
      "name": name,
      "pass": pass,
      "phone": phone
    },
  );

  // ...

  // ...

  final QueryResult result = await _client.mutate(options);

  if (result.hasException) {
      print(result.exception.toString());
      return false;
  }

  print(result.data);
  return true;

  // final bool isStarred =
  //     result.data['insert_User']['returning'].length() > 0;

  // if (isStarred) {
  //   print('Thanks for your star!');
  // }
  //   return isStarred;

  // ...
}

const String login = r'''
  query login($email: String = "", $pass: String = "") {
  User(where: {email: {_eq: $email}, pass: {_eq: $pass}}) {
    name
    phone
  }
}


''';

Future<List> iniciandoSesion({@required String email, @required String pass})async{

  // const int nRepositories = 50;

  final QueryOptions options = QueryOptions(
      documentNode: gql(login),
      variables: <String, dynamic>{
        "email": email,
        "pass": pass
      },
  );
  // ...

  final QueryResult result = await _client.query(options);

  if (result.hasException) {
      // Flushbar(
      //     title:  "Fallo inicio de sesion",
      //     message:  result.exception.toString(),
      //     backgroundColor: Colors.red,
      //     duration:  Duration(seconds: 3),              
      //   )..show(context);
      print(result.exception.toString());
  }
  print("#########################");
  print(result.data);
  // return true;
  final List repositories =
      result.data['User'];


  return repositories;
  // ...
}

limpiarGrapql(){
  _client.cache.reset();
}

/////////////////
const String insertM = r'''
  mutation InsertMuseo($name: String = "", $description: String = "", $diasHabiles: json = "", $horarioApertura: String = "", $horarioCierre: String = "", $imageURL: String = "", $ubicacion: String = "") {
  insert_Museo(objects: {name: $name, description: $description, diasHabiles: $diasHabiles, horarioApertura: $horarioApertura, horarioCierre: $horarioCierre, imageURL: $imageURL, ubicacion: $ubicacion}) {
    returning {
      idMuseo
      name
      imageURL
      ubicacion
      horarioApertura
      horarioCierre
      diasHabiles
      description
    }
  }
}

''';

Future<bool> insertMuseo({String name, String description, Map diasHabiles,String horarioApertura, String horarioCierre, String imageURL, String ubicacion})async{
  final MutationOptions options = MutationOptions(
    documentNode: gql(insertM),
    variables: <String, dynamic>{
      "name": name,
      "description": description,
      "diasHabiles": diasHabiles,
      "horarioApertura": horarioApertura,
      "horarioCierre": horarioCierre,
      "imageURL": imageURL,
      "ubicacion": ubicacion
    },
  );

  // ...

  // ...

  final QueryResult result = await _client.mutate(options);

  if (result.hasException) {
      print(result.exception.toString());
      return false;
  }

  print(result.data);
  return true;

  // final bool isStarred =
  //     result.data['insert_User']['returning'].length() > 0;

  // if (isStarred) {
  //   print('Thanks for your star!');
  // }
  //   return isStarred;

  // ...
}

const String consultarMus = r'''
  query ConsultarMuseo {
  Museo {
    name
    imageURL
    horarioApertura
    horarioCierre
    diasHabiles
  }
}



''';

Future<List> consultarMuseo()async{

  // const int nRepositories = 50;

  final QueryOptions options = QueryOptions(
      documentNode: gql(consultarMus),
      // variables: <String, dynamic>{
      //   "email": email,
      //   "pass": pass
      // },
  );
  // ...

  final QueryResult result = await _client.query(options);

  if (result.hasException) {
      // Flushbar(
      //     title:  "Fallo inicio de sesion",
      //     message:  result.exception.toString(),
      //     backgroundColor: Colors.red,
      //     duration:  Duration(seconds: 3),              
      //   )..show(context);
      print(result.exception.toString());
  }
  print("#########################");
  print(result.data);
  // return true;
  final List repositories =
      result.data['Museo'];


  return repositories;
  // ...
}