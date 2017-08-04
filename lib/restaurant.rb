# restaurant class
class Restaurant
  @filepath = nil

  attr_accessor :name, :cuisine, :price, :filepath

  # setter method for filepath
  def self.filepath=(path = nil)
    @filepath = File.join(APP_ROOT, path)
  end

  def self.filepath
    @filepath
  end

  # validation for files
  def self.usable?
    return false unless @filepath
    return false unless File.exist?(@filepath)
    return false unless File.readable?(@filepath)
    return false unless File.writable?(@filepath)
    true
  end

  # create new file
  def self.create_file
    File.new(@filepath, 'w') unless File.exist?(@filepath)
    usable?
  end

  # retrieve all the restaurants info from file
  def self.saved_restaurants
    res = []
    if usable?
      file = File.new(@filepath, 'r')
      file.each_line { |line| res << Restaurant.new.import_info(line.chomp) }
      file.close
    end
    res
  end

  # method used in saved_restaurants for getting restaurants info line by line
  def self.build_info
    args = {}
    args[:name] = gets.chomp
    puts 'Restaurant Type :'
    puts 'Restaurant Name :'
    args[:cuisine] = gets.chomp
    puts 'Restaurant Average Price :'
    args[:price] = gets.chomp
    new(args)
  end

  # method for appending data in the restaurants.txt file
  def save
    return false unless Restaurant.usable?
    File.open(Restaurant.filepath, 'a') do |file|
      file.puts("#{[@name, @cuisine, @price].join("\t")}\n")
    end
    true
  end

  # constructor
  def initialize(args = {})
    @name    = args[:name]    || ''
    @cuisine = args[:cuisine] || ''
    @price   = args[:price]   || ''
  end

  # method for importing restaurant info one by one
  def import_info(line)
    line_arr = line.split("\t")
    # assigning array to the instance variable
    @name, @cuisine, @price = line_arr
    self
  end
end
