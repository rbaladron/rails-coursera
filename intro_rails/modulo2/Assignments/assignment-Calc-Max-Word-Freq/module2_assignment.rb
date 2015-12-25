class LineAnalyzer
  # Attributes:
  #* highest_wf_count - a number with maximum number of occurrences for a single word (calculated)
  #* highest_wf_words - an array of words with the maximum number of occurrences (calculated)
  #* content,         - the string analyzed (provided)
  #* line_number      - the line number analyzed (provided)
  attr_reader :highest_wf_count, :highest_wf_words, :content, :line_number

  def initialize(content, line_number)
    @content = content
    @line_number = line_number
    calculate_word_frequency

  end
  # Calculates the maximum number of times a single word appears within
  #  provided content and store that in the highest_wf_count attribute.
  #* identify the words that were used the maximum number of times and
  #  store that in the highest_wf_words attribute.
  def calculate_word_frequency
    wf_count = Hash.new(0)
    @content.split.each do |word|
      wf_count[word.downcase] += 1
    end
    @highest_wf_count = wf_count.values.max

    @highest_wf_words = Array.new
    wf_words_count.each_pair do[word, count]
      @highest_wf_words << word if count == @highest_wf_count
    end
  end
end

class Solution

  # Attributes:
  #* analyzers - an array of LineAnalyzer objects for each line in the file
  #* highest_count_across_lines - a number with the maximum value for highest_wf_words attribute in the analyzers array.
  #* highest_count_words_across_lines - a filtered array of LineAnalyzer objects with the highest_wf_words attribute
  #  equal to the highest_count_across_lines determined previously.
  attr_reader :analyzers, :highest_count_across_lines, :highest_count_words_across_lines

  def initialize
    @analyzers = Array.new
  end

  # Processes 'test.txt' intro an array of LineAnalyzers and stores them in analyzers.
  def analyze_file
    if File.exists? "test.txt"
      line_number = 0
      File.foreach("text.txt") do |line|
        @analyzers << LineAnalyzer.new(line, line_number += 1)
      end
    end
  end

  # Determines the highest_count_across_lines and
  #  highest_count_words_across_lines attribute values
  def calculate_line_with_highest_frequency
    word_count_across_lines = Hash.new(0)

    @analyzers.each do |line|
      line.content.split.each do |word|
        word_count_across_lines[word] +=1
      end
    end

    @highest_count_words_across_lines = Array.new
    @analyzers.each do |line|
    line.highest_wf_words.each do |word|
      @highest_count_words_across_lines << line if word_count_across_lines[word] == @highest_count_across_lines
      end
    end
  end

  #* print_highest_word_frequency_across_lines() - prints the values of LineAnalyzer objects in
  #  highest_count_words_across_lines in the specified format:
  #  The following words have the highest word frequency per line:
  #   ["word1"] (appears in line #)
  #   ["word2", "word3"] (appears in line #)
  def print_highest_word_frequency_across_lines
    puts "The following words have the highest word frequency per line:"
    @analyzers.each do |analyzer|
      puts "#{analyzer.highest_wf_words} (appears in line #{analyzer.line_number})"
    end
  end
end
