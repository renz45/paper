module PostsHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        add_line_numbers(Pygments.highlight(code, lexer: language))
      end
    end

    def add_line_numbers(code)
      current_line = 0
      code_arr = code.split("\n")
      total_lines = code_arr.count
      code_arr.map! do |line|
        current_line += 1
        if current_line == 1
          line.gsub!('<pre>', "<pre><span class='line-number'>#{current_line}:</span> ")
        elsif current_line == total_lines
          line
        else
          "<span class='line-number'>#{current_line}:</span> #{line}"
        end
      end

      code_arr << "<div class='toolbar'><a href='#' title: 'Toggle Line Numbers' class='toggle-line-numbers'><i class='icon-list-ol'></i></a></div>"

      code_arr.join("\n")
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: false)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end