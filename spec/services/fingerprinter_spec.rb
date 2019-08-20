require 'rails_helper'

RSpec.describe Fingerprinter, type: :service do
  # before { create :bucket, id: 1 }
  before { Bucket.create! id: 1 }

  describe '#parse_artists' do
    it 'should parse a single artist ' do
      result = Fingerprinter.parse_artists([{"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "name"=>"Kanye West"}])
      expect(result).to eq([{ primary: true, name: 'Kanye West', ext_id: '164f0d73-1234-4e2c-8743-d77bf2191051'}])
    end

    it 'should parse 2 primary artists and a secondary' do
      result = Fingerprinter.parse_artists([{"id"=>"f82bcf78-5b69-4622-a5ef-73800768d9ac", "joinphrase"=>" & ", "name"=>"JAY Z"},
                   {"id"=>"164f0d73-1234-4e2c-8743-d77bf2191051", "joinphrase"=>" feat. ", "name"=>"Kanye West"},
                   {"id"=>"859d0860-d480-4efd-970c-c05d5f1776b8", "name"=>"Beyoncé"}])
      expect(result).to eq([{name: 'JAY Z', primary: true, ext_id: 'f82bcf78-5b69-4622-a5ef-73800768d9ac'},
                   {name: 'Kanye West', primary: false, ext_id: '164f0d73-1234-4e2c-8743-d77bf2191051'},
                   {name: 'Beyoncé', primary: false, ext_id: '859d0860-d480-4efd-970c-c05d5f1776b8'}])
    end
  end
end