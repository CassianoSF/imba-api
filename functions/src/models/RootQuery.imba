import { db } from '../db'

export class RootQuery
    prop query

    def initialize collection_name, where, order, start, limit
        query = db.collection(collection_name)
        query = query.where(where) if where
        query = query.orderBy(order) if order
        query = query.startAt(start) if start
        query = query.limit(limit) if limit

    def where cond
        query = query.where(cond)
        self

    def order_by cond
        query = query.orderBy(cond)
        self

    def skip n
        query = query.startAt(n)
        self

    def limit n
        query = query.limit(n)
        self

    def first
        limit(1)
        data[0]

    def last
        skip(count -1)
        limit(1)
        data[0] 

    def count
        let doc = await query.get()
        doc:size

    def data
        let list = []
        let doc = await query.get()
        doc.forEach do |snapshot|
            let rec = {}
            rec:id = snapshot:id
            let dat = snapshot.data()
            Object.keys(dat).map do |col|
                rec[col] = dat[col] 
            list.push rec
        list