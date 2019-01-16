const User = require('../models/User')

export class UserResolvers

  def isLogin args, request
    typeof request:session:user !== 'undefined'

  def signup args, request
    if User.find_by(username: args:username)
      throw Error.new('Another User with same username exists.')

    data[args:username] =
      pwd: await bcrypt.hashSync(args:pwd, 10)
    yes

  def login args, request
    const user = data[args:username]
    throw Error.new('No Such User exists.') unless user
    throw Error.new('Incorrect password.') unless await bcrypt.compareSync(args:pwd, user:pwd)
    request:session:user = user
    yes

  def logout args, request
    request:session:user = undefined
    yes