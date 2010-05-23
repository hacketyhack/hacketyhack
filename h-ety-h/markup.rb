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
    :class => {:stroke => "#630", :weight => "bold"}
  }

  def highlight str, colors = COLORS
    ary = []
    TOKENIZER.tokenize(str) do |token|
      puts "'#{token}' #{token.group}/#{token.instruction}"
      ary <<
        if colors[token.group]
          span(token, colors[token.group])
        elsif colors[:any]
          span(token, colors[:any])
        else
          token
        end
      # puts "#{token} {group: #{token.group}, instruction: #{token.instruction}}"
    end
    # puts "---"
    ary
  end

  def matching_token(str, pos)
    curr_pos = 0;
    tokens = []
    token_index = nil
    start1 = nil
    end1 = nil
    start2 = nil
    end2 = nil
    TOKENIZER.tokenize(str) do |token|
      curr_pos += token.size
      if curr_pos >= curr_pos and token_index.nil?
        token_index = tokens.size
        start1 = curr_pos
        end1 = curr_pos + token.size
      end
      tokens << token
    end
    if token_index.nil? then return nil end

    if BRACKATS[token]
      pos, len = matching_bracket(tokens, token_index, start1)
    end

    if pos
      start2 = pos
      end2 = pos + len
    end

    [start1, end1, start2, end2]
  end

  def matching_bracket(tokens, index, pos)
    token = tokens['index']
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
      pos += t.size * direction
      if t == matching
        stack_level -= 1
        return [pos, t.size] if stack_level == 0
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
