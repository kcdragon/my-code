require 'init'

class Index
  attr_reader :index_path, :version

  def initialize(index_path, version)
    @index_path = index_path
    @version = version
  end

  def search(query_string)
    reader = DirectoryReader.open(directory)
    searcher = IndexSearcher.new(reader)

    query_parser = QueryParser.new(version, 'text', analyzer)
    query = query_parser.parse(query_string)
    results = searcher.search(query, 5)
  end

  def add_document(document)
    writer.add_document(document)
  end

  def close
    writer.close
  end

  def delete_all
    writer.delete_all
  end

  def writer
    @writer ||= IndexWriter.new(directory, index_writer_config)
  end

  private

  def directory
    @directory ||= FSDirectory.open(java.io.File.new(index_path))
  end

  def index_writer_config
    IndexWriterConfig.new(version, analyzer)
  end

  def analyzer
    @analyzer ||= StandardAnalyzer.new(version)
  end
end


index_dir = 'data/'
version = Version::LUCENE_47

analyzer = StandardAnalyzer.new(version)
directory = FSDirectory.open(java.io.File.new(index_dir))

index = Index.new(index_dir, version)
index.delete_all

[
 { text: 'foo' },
 { text: 'foo bar' }
].each do |d|
  document = Document.new
  document.add(TextField.new('text', d[:text],
                             Field::Store::YES))
  index.add_document(document)
end

index.close

results = index.search('foo')

puts results.totalHits
results.scoreDocs.each do |result|
  puts result
end
