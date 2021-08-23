import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyC8Z0MTVR-vC2klrQAfPGRNJHhCbpqqyrA";

User firebaseUser;

Users userCurrentInfo;

User currentFirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;


final assetAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title = "";

String userPhone = "";


double starCounter = 0.0;


