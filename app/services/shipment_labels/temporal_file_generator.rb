# frozen_string_literal: true

require 'open-uri'

module ShipmentLabels
  # Class to generates temporal files
  class TemporalFileGenerator
    DEFAULT_EXTENSION = '.pdf'

    attr_reader :uri, :extension

    def initialize(url, extension = DEFAULT_EXTENSION)
      @uri = URI.parse(url)
      @extension = extension
    end

    def file
      @file ||= Tempfile.new(tmp_filename, tmp_folder, encoding: encoding).tap do |f|
        io.rewind
        f.write(io.read)
      end
    end

    def io
      @io ||= uri.open
    end

    def encoding
      io.rewind
      io.read.encoding
    end

    def tmp_filename
      ["#{Pathname.new(uri.path).basename}-", extension]
    end

    def tmp_folder
      Rails.root.join('tmp')
    end

    def generate_temporal_folder
      FileUtils.mkdir_p(tmp_folder)
    end
  end
end
