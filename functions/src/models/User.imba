const RootRecord = require 'RootRecord.imba'
export class User < RootRecord
	prop username
	prop encrypted_password
	prop email
