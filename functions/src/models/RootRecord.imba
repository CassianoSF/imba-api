const inflection = require 'inflection'

import { db } from '../db'
import { RootQuery } from './RootQuery'

export class RootRecord
    prop collection_name
    prop attributes

    def self.where
        RootQuery.new inflection.pluralize(inflection.underscore(self:name)), ($0)['0'], no, no, no

    def self.all
        RootQuery.new inflection.pluralize(inflection.underscore(self:name)), no, no, no, no

    def self.first
        RootQuery.new inflection.pluralize(inflection.underscore(self:name)), no, 'asc', 0, 1

    def self.last
        RootQuery.new inflection.pluralize(inflection.underscore(self:name)), no, 'desc', 0, 1

    def self.count
        RootQuery.new(inflection.pluralize(inflection.underscore(self:name)), no, no, no, no).count

    def self.find_by args
        let column = Object.keys args
        let all = []
        RootQuery.new(inflection.pluralize(inflection.underscore(self:name)), ["{column}", "==", args[column]], no, no, no).first

    def save
        await db.collection(inflection.pluralize(inflection.underscore(self:name))).add(self)

    def delete
        await db.collection(inflection.pluralize(inflection.underscore(self:name))).doc(id).delete

    def update args
        await db.collection(inflection.pluralize(inflection.underscore(self:name))).doc(id).update(args)


    def initialize
        let myName = RootRecord:caller.toString
        myName = myName.substr 'function ':length
        myName = myName.substr(0, myName.indexOf('('))
        collection_name = inflection.pluralize(inflection.underscore(myName))
        
        let all_properties =  Object.getOwnPropertyNames(RootRecord:caller:prototype)
        console.log all_properties
        attributes = all_properties.slice(3,all_properties:length).filter do |prop, index|
            index % 2 == 0

        attributes.map do |attr|
            self[attr] = null

        let params = (($0)['0'])
        if params
            Object.keys(params).map do |p|
                self[p] = params[p]