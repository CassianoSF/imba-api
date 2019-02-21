var fs = require 'fs'
const admin = require 'firebase-admin'
const functions = require 'firebase-functions'
const session = require 'express-session'
const ms = require 'ms'
const cors = require 'cors'
const express = require 'express'
const graphqlHTTP = require 'express-graphql'
const buildSchema = require('graphql'):buildSchema

import {UserResolvers} from './resolvers/UserResolvers'
import {User} from './models/User'

var app = express()
var schema = buildSchema fs.readFileSync("{__dirname}/schema.graphql", 'utf8')

var root =
  isLogin: do |args, request|
    UserResolvers.new.isLogin args, request

  signup: do |args, request|
    UserResolvers.new.signup args, request

  login: do |args, request|
    UserResolvers.new.login args, request

  logout: do |args, request|
    UserResolvers.new.logout args, request

  users: do 
    User.all.data

app.use cors()

app.use session
  name: 'qid',
  secret: "my_terrible_secret"
  resave: true
  saveUninitialized: true
  cookie:
    secure: process:env:NODE_ENV === 'production'
    maxAge: ms('1d')

app.use '/', graphqlHTTP do |request|
  schema: schema
  rootValue: root
  context: request && console.log(request:body)
  graphiql: true

export const api = functions:https.onRequest(app)