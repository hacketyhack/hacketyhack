require 'h-ety-h/syntax'

module HH::Markup

  TOKENIZER = HH::Syntax.load "ruby"
  COLORS = {
    :comment => {:stroke => "#887"},
    :keyword => {:stroke => "#111"},
    :method => {:stroke => "#C09", :weight => "bold"},
    # :class => {:stroke => "#0c4", :weight => "bold"},
    # :module => {:stroke => "#050"},
    # :punct => {:stroke => "#668", :weight => "bold"},
    :symbol => {:stroke => "#C30"},
    :string => {:stroke => "#C90"},
    :number => {:stroke => "#396" },
    :regex => {:stroke => "#000", :fill => "#FFC" },
    # :char => {:stroke => "#f07"},
    :attribute => {:stroke => "#369" },
    # :global => {:stroke => "#7FB" },
    :expr => {:stroke => "#722" },
    # :escape => {:stroke => "#277" }
    :ident => {:stroke => "#A79"},
    :constant => {:stroke => "#630", :weight => "bold"},
    :class => {:stroke => "#630", :weight => "bold"},
    :matching => {:stroke => "#ff0", :weight => "bold"},
  }

  def highlight str, pos, colors = COLORS
    tokens = []
    TOKENIZER.tokenize(str) {|t| tokens << t}

    res = []
    tokens.each do |token|
      #puts "'#{token}' #{token.group}/#{token.instruction}"
      res <<
        if colors[token.group]
          span(token, colors[token.group])
        elsif colors[:any]
          span(token, colors[:any])
        else
          token
        end
      # puts "#{token} {group: #{token.group}, instruction: #{token.instruction}}"
    end

    token_index, matching_index = matching_token(tokens, pos)

    puts token_index if token_index
    puts matching_index if matching_index
    puts "---"

    if token_index
      res[token_index] = span(tokens[token_index], colors[:matching])
      if matching_index
        res[matching_index] = span(tokens[matching_index], colors[:matching])
      end
    end

    res
  end

  def matching_token(tokens, pos)
    curr_pos = 0
    tokens = []
    token_index = nil
    matching_index = nil
    tokens.each do |t|
      curr_pos += t.size
      if token_index.nil? and curr_pos >= pos
        token_index = tokens.size
        break
      end
    end
    if token_index.nil? then return nil end

    token = tokens[token_index]
    if BRACKETS.include?(token)
      matching_index = matching_bracket(tokens, token_index)
    end

    [token_index, matching_index]
  end

  def matching_bracket(tokens, index)
    token = tokens[index]
    if (matching = OPEN_BRACKETS[token])
      direction = 1
    elsif (matching = CLOSE_BRACKETS[token])
      direction = -1
    else
      # something strange happened..
      raise "internal error: unknown bracket"
    end

    stack_level = 1
    while index >= 0 and index < tokens.size
      index += direction
      t = tokens[index]
      if t == matching
        stack_level -= 1
        return index if stack_level == 0
      elsif t == token
        stack_level += 1
      end
    end
    return nil
  end

  OPEN_BRACKETS = {
    '{' => '}',
    '(' => ')',
    '[' => ']',
  }

  #close_bracket = {}
  #OPEN_BRACKETS.each{|open, close| opens_bracket[close] = open}
  #CLOSE_BRACKETS = opens_bracket
  # the following is more readable :)
  CLOSE_BRACKETS = {
    '}' => '{',
    ')' => '(',
    ']' => '[',
  }

  BRACKETS = CLOSE_BRACKETS.keys + OPEN_BRACKETS.keys

#  MATCH_CLOSES = {
#    ['do', :keyword] => ['end'],
#    ['class', :keyword] => ['end'],
#    ['module', :keyword] => ['end'],
#    ['def', :keyword] => ['end'],
#    ['if', :keyword] => ['end'],
#    ['{', :punct] => ['}'],
#    ['[', :punct] => [']'],
#    ['(', :punct] => [')']
#  }

end
