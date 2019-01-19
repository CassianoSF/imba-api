import { db } from '../db'

export class RootQuery
    prop query

    def initialize collection_name, _where, _order, _skip, _limit
        query = db.collection(collection_name)
        where(_where) if _where
        order(_order) if _order
        skip(_skip) if _skip
        limit(_limit) if _limit

    def where cond
        query = query.where(cond[0], cond[1], cond[2])
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
        (await data)[0]

    def last
        skip(count -1)
        limit(1)
        await data[0] 

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