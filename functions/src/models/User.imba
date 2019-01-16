import { db } from '../db'

export class User
    attr id
    attr username
    attr encrypted_password
    attr email

    def self.objectify doc
        let result = {}
        result:id = doc:id
        let data = doc.data()
        Object.keys(data).map do |col|
            result[col] = data[col] 
        return result

    def self.all
        let snapshot = await db.collection('users').get()
        let all = []
        snapshot.forEach do |doc|
            all.push objectify(doc)
        return all

    def self.find_by args
        let column = Object.keys args
        let all = []
        let snapshot = await db.collection('users').where(column, "==", args[column]).get()
        console.log args
        snapshot.forEach do |doc|
            all.push objectify(doc)
        return all
        


    def self.create args
        await db.collection('users').add(args)

    def self.where args
        await db.collection('users').where(args)

    def save
        await db.collection('users').add(self)

    def delete
        await db.collection('users').doc(id).delete

    def update args
        await db.collection('users').doc(id).update(args)
