const bcrypt = require 'bcryptjs'

import { User } from '../models/User'

export class UserResolvers

  def isLogin args, request
    typeof request:session:user !== 'undefined'

  def signup args, request
    let log = await User.find_by("username", "==", args:username)
    if (await User.find_by("username", "==", args:username))
      throw Error.new('Another User with same username exists.')

    await User.new({
      encrypted_password: (await bcrypt.hashSync(args:password, 10))
      username: args:username
      email: args:email
    }).save
    yes

  def login args, request
    const user = User.find_by("username", "==", args:username).data
    throw Error.new('No Such User exists.') unless user
    throw Error.new('Incorrect password.') unless await bcrypt.compareSync(args:pwd, user:pwd)
    request:session:user = user
    yes

  def logout args, request
    request:session:user = undefined
    yes