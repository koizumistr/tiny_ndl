require 'net/http'
require 'rexml/document'

class TinyNdl
  def initialize(proxy_addr = nil, proxy_port = nil)
    @proxy_addr = proxy_addr
    @proxy_port = proxy_port
  end

  attr_reader :title, :title_yomi, :creator, :publisher, :price, :ext, :vol
  attr_reader :summary_array, :id_array

  def search(isbn)
    @elem_array = Array.new
    @summary_array = Array.new
    @id_array = Array.new

#    p isbn
#    p isbn.length
    if isbn.length != 13 and isbn.length != 10 then
      return -2
    end

    @ext = nil
    @vol = nil

    Net::HTTP::Proxy(@proxy_addr, @proxy_port).start('iss.ndl.go.jp', 443, :use_ssl => true) do | session |
      response = session.get("/api/sru?operation=searchRetrieve&recordSchema=dcndl_simple&query=mediatype%3d1%20AND%20isbn%3d#{isbn}")
      if response.code != '200'
        STDERR.puts "#{response.code} - #{response.message}"
        return -1
      end

      @xml = REXML::Document.new(response.body)
#      puts @xml
      num = @xml.root.get_elements('/searchRetrieveResponse/numberOfRecords').first.text
      make_summary

      return num.to_i
    end
  end

  def select(num)
    selelem = @elem_array.at(num - 1)

#    p num.to_s
#    p selelem

    @title = selelem.get_elements('dc:title').first.text
    if selelem.get_elements('dcndl:titleTranscription').first != nil then
      @title_yomi = selelem.get_elements('dcndl:titleTranscription').first.text
    end
    if selelem.get_elements('dc:creator').first != nil then
      @creator = selelem.get_elements('dc:creator').first.text
    end
    @publisher = selelem.get_elements('dc:publisher').first.text
    if selelem.get_elements('dcndl:price').first != nil then
      @price = selelem.get_elements('dcndl:price').first.text
    end
    if selelem.get_elements('dc:extent').first != nil then
    @ext = selelem.get_elements('dc:extent').first.text
    end
    if selelem.get_elements('dcndl:volume').first != nil then
      @vol = selelem.get_elements('dcndl:volume').first.text
    end
  end


  private

  def make_summary
    @xml.elements.each('/searchRetrieveResponse/records/record/recordData/dcndl_simple:dc') do |e|
      @elem_array.push(e)
      text = e.get_elements('dc:title').first.text
      text = text + " / "
      if e.get_elements('dcndl:volume').first != nil then 
        text = text + e.get_elements('dcndl:volume').first.text
      end
      text = text + " / "
      text = text + e.get_elements('dc:creator').first.text + " / "
      if e.get_elements('dc:publisher').first != nil then 
        text = text + e.get_elements('dc:publisher').first.text
      end
      @summary_array.push(text)
      id_text = String.new
      e.elements.each('dc:identifier') do |id|
        if id.attribute('xsi:type').to_s != "dcterms:URI" 
          id_text += id.attribute('xsi:type').to_s + "\t" + id.text + "\n"
        end
      end
      @id_array.push(id_text)
    end
  end
end
