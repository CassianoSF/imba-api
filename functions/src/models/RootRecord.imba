const inflection = require 'inflection'

import { db } from '../db'
import { RootQuery } from './RootQuery'

export class RootRecord
    prop id
    prop collection_name
    prop attributes

    def self.collection_name
        inflection.pluralize(inflection.underscore(self:name))

    def self.where
        RootQuery.new collection_name, ($0)['0'], no, no, no

    def self.all
        RootQuery.new collection_name, no, no, no, no

    def self.first
        RootQuery.new collection_name, no, 'asc', 0, 1

    def self.last
        RootQuery.new collection_name, no, 'desc', 0, 1

    def self.count
        RootQuery.new(collection_name, no, no, no, no).count

    def self.find_by
        let args = Object.values($0)
        let data = RootQuery.new(collection_name, args, no, no, no).first
        return data

    def save
        let thiz = {} 
        attributes.map do |atr|
            thiz[atr] = self[atr]
        
        await db.collection(collection_name).add(thiz)
        

    def delete
        await db.collection(collection_name).doc(id).delete

    def update args
        await db.collection(collection_name).doc(id).update(args)


    def initialize
        let myName = RootRecord:caller.toString
        myName = myName.substr 'function ':length
        myName = myName.substr(0, myName.indexOf('('))
        collection_name = inflection.pluralize(inflection.underscore(myName))
        

        let all_properties =  Object.getOwnPropertyNames(RootRecord:caller:prototype)
        attributes = all_properties.slice(3,all_properties:length).filter do |prop, index|
            index % 2 == 0

        attributes.map do |attr|
            self[attr] = null

        let params = (($0)['0'])
        if params
            Object.keys(params).map do |p|
                self[p] = params[p]