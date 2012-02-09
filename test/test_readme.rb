require 'readme'

testcase Readme do

  fixture = File.dirname(__FILE__) + '/fixture'

  setup do
    @readme = Readme.file(fixture)    
  end

  test 'should find readme file' do
    assert @readme.file 
  end

  test 'should have name' do
    @readme.name.assert == 'readme'
  end

  test 'should have title' do
    @readme.title.assert == 'README'
  end

  test 'should have description' do
    @readme.description.assert.start_with?('Ever thought')
    @readme.description.assert.end_with?('does just that!')
  end

  test 'should have copyrights' do
    @readme.copyright.assert == 'Copyright (c) 2009 Rubyworks. All rights reserved.'
  end

  test 'should have home resource' do
    @readme.resources['home'].assert == 'http://github.com/rubyworks/readme'
  end

  #test 'should have code resource' do
  #  @readme.resources['code'].assert == 'http://rubyworks.github.com/readme'
  #end

  test 'should have mail resource' do
    @readme.resources['mail'].assert == 'http://groups.google.com/groups/rubyworks-mailinglist'
  end

end

