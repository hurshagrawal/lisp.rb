require 'pry'
require 'readline'
require 'env'

class Lisp
  def repl(prompt = 'lisp-rb> ')
    @global_env = create_global_env

    loop do
      begin
        str = Readline.readline(prompt, true)
        val = evaluate(parse(str.strip))
        puts to_s(val) unless val.nil?
      rescue Interrupt
        puts "\nExiting lisp.rb..."
        break
      rescue Exception => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end

  private

    # Parses a lisp string into arrays
    def parse(str)
      read_items(tokenize(str))
    end

    def tokenize(str)
      str.gsub('(', ' ( ').gsub(')', ' ) ').split(' ')
    end

    def read_items(token_array)
      if token_array.length == 0
        raise 'Unexpected end of input'
      end

      token = token_array.shift

      case token
      when '('
        list = []
        while token_array.first != ')'
          list.push(read_items(token_array))
        end
        token_array.shift # Remove ')'
        list
      when ')'
        raise 'Unexpected end parentheses'
      else
        detect_type(token)
      end
    end

    def detect_type(token)
      if is_number?(token)
        if token =~ /\./
          token.to_f
        else
          token.to_i
        end
      else
        token
      end
    end

    def is_number?(str)
      true if Float(str) rescue false
    end

    def evaluate(x, env = @global_env)
      if false
      else
        exps = x.map {|token| evaluate(token) }
        procedure = exps.shift
        procedure.call(*exps)
      end
    end

    # Converts a ruby array back into a lisp string
    def to_s(exp)
      if exp.is_a?(Array)
        "( #{exp.map{ |t| to_s(t) }.join(' ')} )"
      else
        exp.to_s
      end
    end

    def create_global_env
      env = Env.new
      env.update(
        '+' => lambda { |*args| args.sum },
        '-' => lambda { |a, b| a - b },
        '*' => lambda { |*args| args.inject(1) {|product, a| product * a } },
        '/' => lambda { |a, b| a / b },
        '>' => lambda { |a, b| a > b },
        '<' => lambda { |a, b| a < b },
        '>=' => lambda { |a, b| a >= b },
        '<=' => lambda { |a, b| a <= b },
        'not' => lambda { |a| !a },
        'cons' => lambda { |a, b| [a] + b },
        'car' => lambda { |a| a.first },
        'cdr' => lambda { |a| a.drop(1) },
        'list' => lambda { |*args| args },
        'list?' => lambda { |a| a.is_a?(Array) },
        'nil?' => lambda {|a| a.nil? },
        'equal?' => lambda { |a, b| a == b },
        'true' => true,
        'false' => false
      )
      env
    end
end

Lisp.new.repl
