# encoding: UTF-8
require "pry"

require_relative 'predictor'

class ComplexPredictor < Predictor
  # Public: Trains the predictor on books in our dataset. This method is called
  # before the predict() method is called.
  #
  # Returns nothing.
  def train!
    @data = {}

    @all_books.each do |cat, books|
      @data[cat] = {
        words: {},
        # popular_words: {},
        books: 0
      }

      books.each do |filename, tokens|
        # @data[category][:words] += tokens.count
        # @data[category][:books] += 1

        tokens.each do |word|
          if good_token?(word)
            if @data[cat][:words][word]
              @data[cat][:words][word] += 1
            else
              @data[cat][:words][word] = 1
            end
          end
        end # here we have a count of words
      end # Finish collecting all the book infos

      #We need to figure out most popular words
      @data[cat][:words].keep_if do |word, count| 
        # if count > 1000
        #   @data[cat][:popular_words][word] = count
        # end
        count > 50
      end
    end
  end

  # Public: Predicts category.
  #
  # tokens - A list of tokens (words).
  #
  # Returns a category.
  def predict(tokens)
    data_book = {}

    tokens.each do |word|
      if good_token?(word)
        if data_book[word]
          data_book[word] += 1
        else
          data_book[word] = 1
        end
      end
    end

    average = get_average(data_book)

    data_book.keep_if do |word, count|
      count > average
    end

    results = {}

    @data.each_pair do |cat, record|
      results[cat] = 0
      record[:words].each_key do |word|
        if data_book.keys.include? word
          results[cat] += 1
        end
      end
    end

    most_hits = results.values.max
    results.each_pair do |cat, hits|
      if hits == most_hits
        return cat
      end
    end

  end

  private

  def get_average(data_book)
    average = 0
    data_book.each_value do |count|
      average += count
    end
    average = average / (data_book.count * 0.15)
    average
  end
end

