require 'spec_helper'

describe Jedi do

  around :example do |ex|
    FileUtils.chdir "sample"; ex.run; FileUtils.chdir ".."
  end

  it 'should get gem configs' do
    expect(Jedi.config).to be_an_instance_of Jedi::Config
  end

end