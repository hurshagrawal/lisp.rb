require 'pry'

class Lisp
  def repl(prompt = 'lisp-rb> ')
    loop do
      begin
        print prompt
        str = gets.strip
        val = evaluate(parse(str))
        puts val unless val.nil?
      rescue Interrupt
        puts "\nExiting lisp.rb..."
        break
      rescue Exception => e
        puts "\nAn error occured!"
        puts e.inspect
        puts e.backtrace
        break
      end
    end
  end

  # Parses a lisp string into arrays
  def parse(str)
    token_array = str.gsub('(', ' ( ').gsub(')', ' ) ').split(' ')
    convert_to_lists(token_array)
  end

  def convert_to_lists(token_array)
    if token_array.first != '(' || token_array.last != ')'
      return error("Not a valid string.")
    end

    token_array = token_array[1...-1]

    i = 0
    arr = []
    while i < token_array.length do
      token = token_array[i]
      if token == '('
        end_paren = token_array[i..-1].index(")") + i
        token = convert_to_lists(token_array[i..end_paren])
        i = end_paren
      elsif is_number?(token)
        token = token =~ /\./ ? token.to_f : token.to_i
      end

      arr << token
      i += 1
    end

    arr
  end

  def is_number?(str)
    true if Float(str) rescue false
  end

  def evaluate(token_array)
    token_array
  end

  def error(text)
    "Error: #{text}"
  end

end

lisp = Lisp.new
lisp.repl
