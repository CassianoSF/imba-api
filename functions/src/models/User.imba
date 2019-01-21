import { RootRecord, test } from './RootRecord'

export class User < RootRecord
	field :username,           :string
	field :encrypted_password, :string
	field :email,              :string

	validates_presence_of :username, :encrypted_password, :email
