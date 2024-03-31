require 'json'

class Post
  attr_accessor :title, :author, :content, :created_at

  def initialize(title, author, content, created_at = Time.now)
    @title = title
    @author = author
    @content = content
    @created_at = created_at
  end

  def display
    puts "\nTitle: #{@title}"
    puts "Author: #{@author}"
    puts "Posted At: #{@created_at}"
    puts "Content: #{@content}\n\n"
    puts "--------------------------------------"
  end

  # Convert the post to a hash suitable for JSON serialization
  def to_h
    { title: @title, author: @author, content: @content, created_at: @created_at }
  end

  # Instantiate a post from a hash
  def self.from_h(hash)
    new(hash[:title], hash[:author], hash[:content], hash[:created_at])
  end
end

class Blog
  def initialize
    @posts = load_posts
  end

  def add_post
    puts "Enter the title of the post:"
    title = gets.chomp
    puts "Enter the author's name:"
    author = gets.chomp
    puts "Enter the post content:"
    content = gets.chomp

    @posts << Post.new(title, author, content)
    puts "Post created successfully!"
    save_posts
  end

  def list_posts
    puts "\nExisting posts (newest first):"
    @posts.sort_by(&:created_at).reverse.each(&:display)
  end

  def search_posts
    puts "Enter search keyword:"
    keyword = gets.chomp.downcase

    posted = @posts.select do |post|
      post.title.downcase.include?(keyword) || post.author.downcase.include?(keyword)
    end

    if posted.empty?
      puts "No posts found matching your search."
    else
      posted.each(&:display)
    end
  end

  def remove_post
    puts "Enter the title of the post you want to remove:"
    title = gets.chomp

    post_to_remove = @posts.find { |post| post.title.downcase == title.downcase }

    if post_to_remove
      @posts.delete(post_to_remove)
      puts "Post removed successfully."
      save_posts
    else
      puts "No post found with that title."
    end
  end

  def save_posts
    File.open("posts.json", "w") do |file|
      file.write(@posts.map(&:to_h).to_json)
    end
  end

  def load_posts
    return [] unless File.exist?("posts.json")
    JSON.parse(File.read("posts.json"), symbolize_names: true).map do |post_hash|
      Post.from_h(post_hash)
    end
  rescue
    []
  end

  def run
    loop do
      puts "\nWelcome to the Simple Blog System!"
      puts "1. Create a post"
      puts "2. List all posts"
      puts "3. Search for a post"
      puts "4. Remove a post"
      puts "5. Exit"
      print "> "

      choice = gets.chomp.to_i
      case choice
      when 1
        add_post
      when 2
        list_posts
      when 3
        search_posts
      when 4
        remove_post
      when 5
        puts "Exiting..."
        break
      else
        puts "Invalid option. Please try again."
      end
    end
  end
end

# Start the blog system
blog = Blog.new
blog.run
