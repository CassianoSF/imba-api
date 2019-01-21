const admin = require 'firebase-admin'
const functions = require 'firebase-functions'

admin.initializeApp functions.config:firebase

var db = admin.firestore

db.settings({ timestampsInSnapshots: true });

export var db = db
