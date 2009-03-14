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

end
