java_import org.nerdpower.tabula.Table


class Table
  # create a new Table object from an array of arrays, representing a list of rows in a spreadsheet
  # probably only used for testing
  def self.new_from_array(array_of_rows)
    t = Table.new
    @extraction_method = "testing"
    tlines = []
    array_of_rows.each_with_index do |row, i|
      l = Line.new
      l.text_elements = row.each_with_index.map { |cell, j|
        TextElement.new(i.to_java(:float), j.to_java(:float), 1, 1, nil, 0, cell, 0)
      }
      tlines << l
    end
    t.instance_variable_set(:@lines, tlines)
    t
  end

  def to_json(*a)
    sb = java.lang.StringBuilder.new
    org.nerdpower.tabula.writers.JSONWriter.new.write(sb, self)
    sb.toString
  end

  def to_csv
    sb = java.lang.StringBuilder.new
    org.nerdpower.tabula.writers.CSVWriter.new.write(sb, self)
    sb.toString
  end

  def to_tsv
    sb = java.lang.StringBuilder.new
    org.nerdpower.tabula.writers.TSVWriter.new.write(sb, self)
    sb.toString
  end

  protected

  #for equality testing, return @lines stripped of leading columns of empty strings
  #TODO: write a method to strip all totally-empty columns (or not?)
  def lstrip_lines
    min_leading_empty_strings = ::Float::INFINITY
    lines.each do |line|
      empties = line.text_elements.map{|t| t.nil? || t.text.empty? }
      min_leading_empty_strings = [min_leading_empty_strings,
                                   empties.index(false) || 0].min
    end
    if min_leading_empty_strings == 0
      lines
    else
      (0...lines.size).each do |i|
        lines[i].text_elements.removeRange(0, min_leading_empty_strings)
      end
      lines
    end
  end
  def lstrip_lines!
    #@lines = self.lstrip_lines
    lstrip_lines
  end

  attr_accessor :lines

end


module Tabula
  Table = ::Table
end
