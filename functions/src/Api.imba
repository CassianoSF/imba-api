const admin = require 'firebase-admin'
const functions = require 'firebase-functions'
const session = require 'express-session'
const bcrypt = require 'bcryptjs'
const ms = require 'ms'
const cors = require 'cors'
const express = require 'express'
const graphqlHTTP = require 'express-graphql'
const buildSchema = require('graphql'):buildSchema
import {User} from './models/User'

var app = express()

var schema = buildSchema '
  type Query {
    isLogin: Boolean!
    users: [User]
  }

  type Mutation {
    login(username: String!, pwd: String!): Boolean!
    signup(username: String!, pwd: String!): Boolean!
    logout: Boolean!
  }

  type User {
    id: String!
    email: String!
    encrypted_password: String!
    username: String!
  }
'
var data = {}

var root =
  isLogin: do |args, request|
    typeof request:session:user !== 'undefined'

  signup: do |args, request|
    if (data[args:username])
      throw Error.new('Another User with same username exists.')

    data[args:username] =
      pwd: await bcrypt.hashSync(args:pwd, 10)
    yes

  login: do |args, request|
    const user = data[args:username]
    throw Error.new('No Such User exists.') unless user
    throw Error.new('Incorrect password.') unless await bcrypt.compareSync(args:pwd, user:pwd)
    request:session:user = user
    yes

  logout: do |args, request|
    request:session:user = undefined
    yes

  users: do |args, request|
    User.find_by({email: "Ada2"}) 

app.use cors()

app.use session
  name: 'qid',
  secret: "H71aj12(Vasd&*!asc91usbd1*!!YSDC"
  resave: true
  saveUninitialized: true
  cookie:
    secure: process:env:NODE_ENV === 'production'
    maxAge: ms('1d')

app.use '/', graphqlHTTP do |request|
  schema: schema
  rootValue: root
  context: request:session
  graphiql: true

# var db = require('./db'):db

# def get db
#   var snapshot = await db.collection('users').get()
#   var result = []
#   snapshot.forEach do |doc|
#     let rec = {}
#     rec:id = doc:id
#     let data = doc.data
#     Object.keys(data).map do |col|
#       rec[col] = data[col]
#   console.log result

# def set db
#   var docRef = db.collection('users').doc('alovelace')

#   var setAda = await docRef.set
#     email: 'Ada2'
#     encrypted_password: 'Lovelace2'
#     username: "18152"
#   console.log setAda


# set(db)
# get(db)

export const api = functions:https.onRequest(app)