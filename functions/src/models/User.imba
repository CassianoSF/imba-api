import { RootRecord, test } from './RootRecord'

export class User < RootRecord
    attr username
    attr encrypted_password
    attr email
    test :this