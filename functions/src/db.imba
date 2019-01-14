require "firebase/firestore"
const firebase = require "firebase"

firebase.initializeApp
  apiKey: "AIzaSyCZERwxLSlk7fYpLTGJlEBaLn9TaFB0eoQ"
  authDomain: 'imba-dashboard.firebaseapp.com'
  projectId: 'imba-dashboard'

export var db = firebase.firestore()