require 'net/http'
require 'rexml/document'

class TinyNdl
  BIB_RES = 'rdf:RDF/dcndl:BibResource/'

  def initialize(proxy_addr = nil, proxy_port = nil)
    @proxy_addr = proxy_addr
    @proxy_port = proxy_port
  end

  attr_reader :title, :title_yomi, :creator, :publisher, :price, :ext, :vol, :summary_array

  def search(isbn)
    @rd_array = []
    @summary_array = []

    #    p isbn
    #    p isbn.length
    return -2 if (isbn.length != 13) && (isbn.length != 10)

    @title = nil
    @title_yomi = nil
    @creator = nil
    @publisher = nil
    @price = nil
    @ext = nil
    @vol = nil

    Net::HTTP::Proxy(@proxy_addr, @proxy_port).start('ndlsearch.ndl.go.jp', 443, use_ssl: true) do |session|
      response = session.get("/api/sru?operation=searchRetrieve&recordSchema=dcndl&query=mediatype%3dbooklet%20AND%20isbn%3d#{isbn}")
      if response.code != '200'
        warn "#{response.code} - #{response.message}"
        return -1
      end

      @xml = REXML::Document.new(response.body)
#      puts @xml
      num = if !@xml.root.get_elements('/searchRetrieveResponse/numberOfRecords').first.nil?
              @xml.root.get_elements('/searchRetrieveResponse/numberOfRecords').first.text
            else
              0
            end

      make_summary

      return num.to_i
    end
  end

  def select(num)
    rdf = REXML::Document.new(@rd_array.at(num - 1))
#    p num.to_s

    @title = rdf.get_elements("#{BIB_RES}dcterms:title").first.text
    unless rdf.get_elements("#{BIB_RES}dc:title/rdf:Description/dcndl:transcription").first.nil?
      @title_yomi = rdf.get_elements("#{BIB_RES}dc:title/rdf:Description/dcndl:transcription").first.text
    end
    unless rdf.get_elements("#{BIB_RES}dc:creator").first.nil?
      @creator = rdf.get_elements("#{BIB_RES}dc:creator").first.text
    end
    @publisher = rdf.get_elements("#{BIB_RES}dcterms:publisher/foaf:Agent/foaf:name").first.text
    unless rdf.get_elements("#{BIB_RES}dcndl:price").first.nil?
      @price = rdf.get_elements("#{BIB_RES}dcndl:price").first.text
    end
    unless rdf.get_elements("#{BIB_RES}dcterms:extent").first.nil?
      @ext = rdf.get_elements("#{BIB_RES}dcterms:extent").first.text
    end
    return if rdf.get_elements("#{BIB_RES}dcndl:volume/rdf:Description/rdf:value").first.nil?

    @vol = rdf.get_elements("#{BIB_RES}dcndl:volume/rdf:Description/rdf:value").first.text
  end

  private

  def make_summary
    @xml.elements.each('searchRetrieveResponse/records/record/recordData') do |e|
#      puts e.text
      c = e.text
      @rd_array.push(c)
      rdf = REXML::Document.new(c)

      text = rdf.get_elements("#{BIB_RES}dcterms:title").first.text
#      puts text
      text += ' / '
      unless rdf.get_elements("#{BIB_RES}dcndl:volume/rdf:Description/rdf:value").first.nil?
        text += rdf.get_elements("#{BIB_RES}dcndl:volume/rdf:Description/rdf:value").first.text
      end
      text += ' / '
      unless rdf.get_elements("#{BIB_RES}dc:creator").first.nil?
        text += rdf.get_elements("#{BIB_RES}dc:creator").first.text
      end
      text += ' / '
      unless rdf.get_elements("#{BIB_RES}dcterms:publisher/foaf:Agent/foaf:name").first.nil?
        text += rdf.get_elements("#{BIB_RES}dcterms:publisher/foaf:Agent/foaf:name").first.text
      end
      @summary_array.push(text)
    end
  end
end
