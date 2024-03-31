class Post
    attr_accessor :title, :author, :content, :created_at
  
    def initialize(title, author, content)
      @title = title
      @author = author
      @content = content
      @created_at = Time.now
    end
  
    def display
      puts "Title: #{@title}"
      puts "Author: #{@author}"
      puts "Posted At: #{@created_at}"
      puts "Content: #{@content}"
      puts "--------------------------------------"
    end
  end
  
  class Blog
    def initialize
      @posts = []
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
    end
  
    def list_posts
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
    def remove_posts
    puts "Enter the title of the post you want to remove:"
    title= gets.chomp
    posts_to_remove= @posts.find {|post| post.title.downcase == title.downcase}
    if posts_to_remove
        @posts.delete(posts_to_remove)
        puts "Post removed successfully."
      else
        puts "No post found with that title."
    end 
  end
  
    def run
      loop do
        puts "\nWelcome to Create a blog!"
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
          remove_posts
        when 5
          puts "Exiting "
          break
        else
          puts "Invalid option. Please try again."
        end
      end
    end
  end

  # Outside of your class definitions at the bottom of the file
  blog = Blog.new
  blog.run
  