const db = require('../db.imba')

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