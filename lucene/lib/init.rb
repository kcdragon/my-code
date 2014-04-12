require 'java'
require 'lucene-core-4.7.1'
require 'lucene-analyzers-common-4.7.1'
require 'lucene-queryparser-4.7.1'

java_import 'org.apache.lucene.analysis.core.SimpleAnalyzer'
java_import 'org.apache.lucene.analysis.core.StopAnalyzer'
java_import 'org.apache.lucene.analysis.core.WhitespaceAnalyzer'
java_import 'org.apache.lucene.analysis.standard.StandardAnalyzer'
java_import 'org.apache.lucene.analysis.tokenattributes.CharTermAttribute'
java_import 'org.apache.lucene.analysis.tokenattributes.OffsetAttribute'

java_import 'org.apache.lucene.document.Document'
java_import 'org.apache.lucene.document.Field'
java_import 'org.apache.lucene.document.StringField'
java_import 'org.apache.lucene.document.TextField'

java_import 'org.apache.lucene.index.DirectoryReader'
java_import 'org.apache.lucene.index.IndexWriter'
java_import 'org.apache.lucene.index.IndexWriterConfig'

java_import 'org.apache.lucene.queryparser.classic.QueryParser'
java_import 'org.apache.lucene.search.IndexSearcher'
java_import 'org.apache.lucene.store.FSDirectory'
java_import 'org.apache.lucene.util.Version'