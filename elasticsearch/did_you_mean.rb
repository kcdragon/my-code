require 'elasticsearch'
require 'pp'
require 'hashie'

@count = 1

INDEX = 'didyoumean-test'
TYPE = 'test'
CLIENT = Elasticsearch::Client.new(log: false)

def delete
  if CLIENT.indices.exists(index: INDEX)
    CLIENT.indices.delete(index: INDEX)
  end
end

def create
  CLIENT.indices.create(index: INDEX,
                        body: {
                          settings: {
                            analysis: {
                              analyzer: {
                                shingle_analyzer: {
                                  type: 'customer',
                                  tokenizer: 'standard',
                                  filter: %w(lowercase shingle)
                                }
                              }
                            }
                          },
                          mappings: {
                            TYPE => {
                              properties: {
                                title: {
                                  type: 'multi_field',
                                  fields: {
                                    title: { type: 'string', analyzer: 'simple' },
                                    shingle: { type: 'string', analyzer: 'shingle_analyzer' }
                                  }
                                }
                              }
                            }
                          }
                        })
end

def refresh
  CLIENT.indices.refresh(index: INDEX)
end

def add(value)
  id = @count
  @count += 1
  CLIENT.index(index: INDEX, type: TYPE, id: id, body: { title: value })
end

def search(options)
  CLIENT.search({index: INDEX}.merge(options))
end

def print(name, results)
  puts name
  results = Hashie::Mash.new(results)
  pp results.suggest
  puts
end

delete
create

[
 'John Cleese',
 'John Gemberling',
 'Johnny Hallyday',
 'Johnny Depp',
 'Joann Sfar',
 'Joanna Rytel',
 'Samuel Johnson',
].each do |text|
  add(text)
end

refresh

results = search(suggest_field: 'title',
                 suggest_text: 'johni depp')
print('Term Suggestor', results)

results = search(body: {
                   suggest: {
                     text: 'johni depp',
                     title: {
                       phrase: {
                         field: 'title'
                       }
                     }
                   }
                 })
print('Phrase Suggestor (Default)', results)

results = search(body: {
                   suggest: {
                     text: 'johni depp',
                     title: {
                       phrase: {
                         analyzer: 'shingle_analyzer',
                         field: 'title'
                       }
                     }
                   }
                 })
print('Phrase Suggestor (Shingle)', results)
