class KeywordsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Keyword.insert_word_into_db
  end
end
