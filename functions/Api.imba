const functions = require 'firebase-functions'
const cors = require 'cors'
const express = require 'express'

const app = express()
app.use(cors({ origin: true }))
app.get "/", do |request, response|
    response.send("Did work")

export const api = functions:https.onRequest(app)