const inflection = require 'inflection'

import { db } from '../db'
import { RootQuery } from './RootQuery'
    

export def test arg
    console.log arg

export class RootRecord
    prop collection_name
    prop fields
    prop errors
    var fields
    

    def self.validates_presence_of
        fields ?= {}
        Object.values($0).map do |field|
            fields[field] ?= {}
            fields[field]:not_null = yes


    def self.field field, type = :string
        fields ?= {}
        fields[field] ?= {}
        fields[field]:type ?= type
    
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

        Object.keys(fields).map do |atr|
            if fields[atr]:not_null and not self[atr]
                errors ?= []
                errors.push "{atr} can't be null."
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

        if fields
            Object.keys(fields).map do |f|
                self[f] = null
            self:fields = fields

        let params = (($0)['0'])
        if params
            Object.keys(params).map do |p|
                self[p] = params[p]