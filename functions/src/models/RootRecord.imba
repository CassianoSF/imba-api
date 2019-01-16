import { db } from '../db'

# var db = require('./db'):db

# def get db
#   var snapshot = await db.collection('users').get()
#   snapshot.forEach do |doc|
#     console.log(doc:id, ':', doc.data())

# def set db
#   var docRef = db.collection('users').doc('alovelace')

#   var setAda = await docRef.set
#     email: 'Ada2'
#     encrypted_password: 'Lovelace2'
#     username: "18152"
#   console.log setAda

class RootRecord
	prop id
	prop model_name
	prop columns
	prop collection_name

	def self.all
		await db.collection(collection_name)

	def self.create args
		await db.collection(collection_name).add(args)

	def save
		let args = columns.map do |c|
			self[c]
		db.collection(collection_name).add(args)

	def delete
		await db.collection(collection_name).doc(id).delete

	def update args
		await db.collection(collection_name).doc(id).update(args)