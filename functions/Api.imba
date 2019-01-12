const functions = require 'firebase-functions'
import { GraphQLServer } from 'graphql-yoga'
const session = require 'express-session'
const bcrypt = require 'bcryptjs'
const ms = require 'ms'

const typeDefs = "
  type Query \{
    isLogin: Boolean!
  }
  type Mutation \{
    login(username: String!, pwd: String!): Boolean!
    signup(username: String!, pwd: String!): Boolean!
  }
"
const data = {}

const resolvers =
  Query:
    isLogin: do |parent, args, ctx|
      typeof ctx:session:user !== 'undefined'

  Mutation:
    signup: do |parent,  args, ctx|
      if (data[args:username])
        throw Error.new('Another User with same username exists.')

      data[args:username] =
        pwd: await bcrypt.hashSync(args:pwd, 10)
      yes

    login: do |parent,  args, ctx|
      const user = data[args:username]
      throw Error.new('No Such User exists.') unless user
      throw Error.new('Incorrect password.') unless await bcrypt.compareSync(args:pwd, user:pwd)
      ctx:session:user = user
      yes

# opts
const opts =
  port: 4000
  cors:
    credentials: yes
    origin: yes

# server
const server = GraphQLServer.new
  typeDefs: typeDefs
  resolvers: resolvers
  context: do |req| req:request


# session middleware
server:express.use session
  name: 'qid'
  secret: "2y0181yb2ef8y13eb0f813yb13f234f2"
  resave: yes
  saveUninitialized: yes
  cookie:
    secure: yes
    maxAge: ms('1d')

# start development server
# server.start opts, do 
  # console.log("Server is running on http://localhost:{opts:port}")

# export server to google firebase functions
export const api = functions:https.onRequest(server:express)