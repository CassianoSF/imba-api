import { db } from '../db.imba'

export class User
	attr username
	attr encrypted_password
	attr email

	def self.all
		await db.collection('users').get()