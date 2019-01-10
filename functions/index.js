const functions = require("firebase-functions")
const cors = require("cors")
const express = require("express")

/* Express with CORS */
const app = express()
app.use(cors({ origin: true }))
app.get("/", (request, response) => {
  response.send("Hello from Express on Firebase with CORS!")
})

const api = functions.https.onRequest(app)

module.exports = {
  api
}