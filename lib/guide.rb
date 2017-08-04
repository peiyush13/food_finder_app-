require 'restaurant'
# guide class for food Finder
class Guide
  # Guide class configuration
  class Config
    @actions = %w[add list find quit]
    def self.action
      @actions
    end
  end

  def initialize(path = nil)
    Restaurant.filepath = path
    if Restaurant.usable?
      puts 'found Restaurant file'
    elsif Restaurant.create_file
      puts 'Restaurant file created'
    else
      puts ' exiting !'
      exit!
    end
  end

  def launch
    introduction
    result = nil
    while result != :quit
      action, args = input_action
      result = do_action(action, args)
    end
    goodbye
  end

  def input_action
    action = nil
    until Guide::Config.action.include?(action)
      puts 'actions => ' + Guide::Config.action.join(' ,') if action
      print '>'
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args = [])
    case action
    when 'add'  then add
    when 'list' then list(args)
    when 'find'
      key = args.shift
      find(key)
    when 'quit' then :quit
    else
      puts 'wrong input !!'
    end
  end

  # method for adding new restaurant
  def add
    puts "\n-- ADD RESTAURANT --\n"
    restaurant = Restaurant.build_info
    if restaurant.save
      puts 'Restaurant added'
    else
      puts 'Save Error => cannot be added'
    end
  end

  # method for gethering list of restaurants by proper sort order
  def list(args = [])
    puts "\n --LISTING RESTAURANT -- \n"
    sort_order = args.shift || 'name'
    sort_order = 'name' unless %w[name cuisine price].include?(sort_order)
    restaurants = Restaurant.saved_restaurants
    restaurants = sort(restaurants, sort_order)
    show(restaurants)
  end

  def sort(restaurants, sort_order)
    restaurants.sort! do |r1, r2|
      if sort_order != 'price'
        r1.send(sort_order).downcase <=> r2.send(sort_order).downcase
      else
        r1.send(sort_order).to_i <=> r2.send(sort_order).to_i
      end
    end
    restaurants
  end

  # method for displaying restaurant list
  def show(restaurants)
    restaurants.each  do |r|
      puts r.name + ' | ' + r.cuisine + ' | ' + r.price
    end
  end

  # method for finding restaurants by keyword , receiving keyword as second arg
  def find(key = '')
    if key
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |res|
        res.name.downcase.include?(key.downcase) ||
          res.cuisine.downcase.include?(key.downcase) ||
          res.price.to_i <= key.to_i
      end
    end
    found.nil? ? 'nothing to show' : show(found)
  end

  # Introductory messsage for Guide
  def introduction
    puts '----- Welcome to Food Finder -----'
    puts '----- Interactive guide for restaurants search -----\n'
  end

  # goodbye msg
  def goodbye
    puts "\nBon appetit !!!\n"
  end
end
