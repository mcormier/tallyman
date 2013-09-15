require 'nokogiri'

class DeltaNotifier

  def initialize(filename)
    xml = File.open( filename)
    doc = Nokogiri::XML(xml)

    @lifts  = doc.xpath('//table[text()="lifts"]').length() != 0
    @books  = doc.xpath('//table[text()="books"]').length() != 0
    @music  = doc.xpath('//table[text()="music"]').length() != 0
    @misc  = doc.xpath('//table[text()="music"]').length() != 0

  end


  def lifts_changed
    @lifts
  end

  def books_changed
    @books
   end

  def music_changed
    @music
  end

  def misc_changed
    @misc
  end

end