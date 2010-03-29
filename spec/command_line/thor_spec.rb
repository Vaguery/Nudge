#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge

describe "thor new_nudge_type MY_TYPE" do
  before(:each) do
  end
  
  describe "documentation" do
    it "should have a desc field"
  end
  
  
  describe "validating type names" do
    it "should check to see the type_name matches the allowed pattern"
    
    it "should quit and warn you if it doesn't match"
  end
  
  
  describe "checking for preexisting files" do
    it "should ask if you already have something there"
    
    it "should replace it without asking if you use '--force'"
    
    it "should replace it if you answer 'yes'"
  end
  
  
  describe "creating core lib/MyType.rb file" do
    it "should use template 'templates/nudge_type_class.tt"
    
    
    it "should require 'nudge'"
    
  end
  
  
  describe "creating boilerplate instruction code" do
    it "should make lib/instructions/foo_define.rb"
    it "should make lib/instructions/foo_equal_q.rb"
    it "should make lib/instructions/foo_duplicate.rb"
    it "should make lib/instructions/foo_flush.rb"
    it "should make lib/instructions/foo_pop.rb"
    it "should make lib/instructions/foo.random.rb" # if it's a candidate for literals
    it "should make lib/instructions/foo_rotate.rb"
    it "should make lib/instructions/foo_shove.rb"
    it "should make lib/instructions/foo_swap.rb"
    it "should make lib/instructions/foo_yank.rb"
  end
end