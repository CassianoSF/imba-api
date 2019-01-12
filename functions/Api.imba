const functions = require 'firebase-functions'
const session = require 'express-session'
const bcrypt = require 'bcryptjs'
const ms = require 'ms'
const cors = require 'cors'
const express = require 'express'
const graphqlHTTP = require 'express-graphql'
const buildSchema = require('graphql'):buildSchema

var app = express()

var schema = buildSchema "
  type Query \{
    isLogin: Boolean!
  }
  type Mutation \{
    login(username: String!, pwd: String!): Boolean!
    signup(username: String!, pwd: String!): Boolean!
  }
"

var data = {}

var root =
  isLogin: do |args, ctx, parent, info|
    typeof ctx:user !== 'undefined'

  signup: do |args, ctx, parent, info|
    if (data[args:username])
      throw Error.new('Another User with same username exists.')

    data[args:username] =
      pwd: await bcrypt.hashSync(args:pwd, 10)
    yes

  login: do |args, ctx, parent, info|
    const user = data[args:username]
    throw Error.new('No Such User exists.') unless user
    throw Error.new('Incorrect password.') unless await bcrypt.compareSync(args:pwd, user:pwd)
    # console.log(Object.keys(args))
    # console.log(Object.keys(ctx))
    # console.log(Object.keys(parent))
    # console.log(Object.keys(info))
    ctx:session = user
    yes

app.use cors()

app.use '/', graphqlHTTP do |request|
  schema: schema
  rootValue: root
  context: console.log(Object.keys(request)) and request:session
  graphiql: true

app.use session
  name: 'qid',
  secret: "H71aj12(Vasd&*!asc91usbd1*!!YSDC"
  resave: true
  saveUninitialized: true
  cookie:
    secure: process:env:NODE_ENV === 'production'
    maxAge: ms('1d')


app.listen(3000)

# export const api = functions:https.onRequest(app)