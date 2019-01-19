import { db } from '../db'
import { RootRecord } from './RootRecord'

export class User < RootRecord
    attr username
    attr encrypted_password
    attr email